{ File ID: PIPES.PAS }

     
PROCEDURE wd (i: INTEGER; VAR w: word);
{-----------------------------------------------------------------}
{ WD should be ...FUNCTION  WD(i: INTEGER): WORD;, but Pascal wont}
{ permit that so we must make it a procedure.....                 }
{-----------------------------------------------------------------}
    BEGIN w.LO := CHR(i MOD 256); w.HI := CHR(i DIV 256); END;
   
PROCEDURE getname (src: STRING; VAR dest: pipename; ln: INTEGER);
{----------------------------------------------------------------}
{ getname - modifies dest so that it is exactly len chars long.  }
{ if src is less than len characters long, dest is padded with   }
{ blanks.  if src is longer than len chars, dest is the first    }
{ len chars of src.....                                          }
{----------------------------------------------------------------}
    VAR i,n: INTEGER;
    BEGIN
    i := LENGTH(src);
    IF i > ln THEN i := ln;
    MOVELEFT(src[1], dest, i);
    IF i < ln THEN
        FOR n := i+1 TO ln DO dest[n] := ' ';
    END; {getname}

{$E+}

FUNCTION pipestatus (VAR names, ptrs: BLOCK): INTEGER;
{----------------------------------------------------------------}
{ pipestatus determines the status of the pipes by reading the name }
{ and pointer tables from the disk.  Each table is 512 bytes in  }
{ length, so 1024 data bytes are returned...                     }
{----------------------------------------------------------------}
    VAR
      i, rcode: INTEGER;
    BEGIN
    WITH reqbuf DO BEGIN
        rqst.size := CHR(FiveByte);
        END; {WITH}
    reqbuf.rqst.command := CHR(Status);
    reqbuf.rqst.statyp := CHR(0);
    reqbuf.LLEN := 5;
    repbuf.LLEN := 1025;
    rcode := result;
    rcode := ORD(repbuf.rply.dcode);
    IF rcode = 0 THEN BEGIN
        MOVELEFT(repbuf.arr[1], names[0], BlockLen);
        MOVELEFT(repbuf.arr[513], ptrs[0], BlockLen);
        for i:=0 to 7 do begin
            if names[i]<>initnames[i+1] then rcode:=PsNotInitted;
            if names[i+504]<>initnames[i+9] then rcode:=PsNotInittedted;
            end;
        END;
    pipestatus := rcode;
    END; {pipestatus}

FUNCTION pipeord (pname: STRING): INTEGER;
{ -------------------------------------------------------------- }
{ FUNCTION pipeord (pname: STRING): INTEGER                     }
{ Opens pipe pname for reading.  A pipe may not be open for both }
{ read and write.  IF spooling is true then the entire pipe list }
{ searched until the name matches and the pipe is closed for read}
{ If spooling is false then we only try to open the first one    }
{ which matches.....                                             }
{ Returns the pipe number if successful, an error code otherwise.}
{ -------------------------------------------------------------- }
    VAR num: INTEGER;
    BEGIN
    reqbuf.LLEN := 10;
    WITH reqbuf, rqst DO BEGIN
        size := CHR(TenByte);
        command := CHR(OpnRd);
        END; {WITH}
    getname (pname,reqbuf.rqst.name,NameLen);
    repbuf.LLEN := 4;
    num := result;
    IF num = 0 THEN pipeord := ORD(repbuf.rply.pipeno)
               ELSE pipeord := num;
    END; {pipeord}

FUNCTION pipeowr (pname: STRING): INTEGER;
{ ------------------------------------------------------------------ }
{ Open a pipe for writing.  Always allocates a new pipe.             }
{ Returns the pipe number or an error code...                        }
{ ------------------------------------------------------------------ }
    VAR num: INTEGER;
    BEGIN
    reqbuf.LLEN := 10;
    WITH reqbuf, rqst DO BEGIN
        size := CHR(TenByte);
        command := CHR(OpnWt);
        END; {WITH}
    getname (pname,reqbuf.rqst.name,NameLen);
    repbuf.LLEN := 4;
    num := result;
    IF num = 0 THEN pipeowr := ORD(repbuf.rply.pipeno)
               ELSE pipeowr := num;
    END; {pipeowr}
 
FUNCTION closeit (npipe,which: INTEGER): INTEGER;
{ ------------------------------------------------------------ }
{ closeit closes pipes for read, write, or purge depending on  }
{ the value of which....                                       }
{ Returns OkCode if successful, error code otherwise.          }
{ ------------------------------------------------------------ }
    BEGIN
    reqbuf.LLEN := 5;
    WITH reqbuf, rqst DO BEGIN
        size := CHR(FiveByte);
        command := CHR(Close);
        pipeno := CHR(npipe);
        state := CHR(which);
        END; {WITH}
    repbuf.LLEN := 2;
    closeit := result;
    END;  {closeit}
   
FUNCTION pipecrd (npipe: INTEGER): INTEGER;
{ ------------------------------------------------------------- }
{ close a pipe for reading.  IF the pipe is empty, it will be   }
{ deallocated.... Returns an error code.                        }
{ ------------------------------------------------------------- }
    BEGIN pipecrd := closeit (npipe,ClsRd) END;

FUNCTION pipecwr (npipe: INTEGER): INTEGER;
{ ------------------------------------------------------------- }
{ close a pipe for writing...                                   }
{ ------------------------------------------------------------- }
    BEGIN pipecwr := closeit (npipe,ClsWt) END;

FUNCTION pipepurge (npipe: INTEGER): INTEGER;
{ ------------------------------------------------------------- }
{ delete a pipe                                                 }
{ ------------------------------------------------------------- }
    BEGIN pipepurge := closeit (npipe,Purge) END;

FUNCTION pipesinit (baddr,bsize: INTEGER): INTEGER;
{ ----------------------------------------------------------------- }
{ initialize the pipe data structures.  baddr is the block number   }
{ of the start of the pipe buffer, bsize is the length in blocks.   }
{ ----------------------------------------------------------------- }
    BEGIN
    IF (baddr < 0) OR (bsize < 0) THEN pipesinit := 0 - 255
    ELSE WITH reqbuf, rqst DO BEGIN
            size := CHR(TenByte);
            command := CHR(PInit);
            wd (baddr, addr);
            wd (bsize, bufsize);
            END; {with}
        reqbuf.LLEN := 10;
        repbuf.LLEN := 2;
        pipesinit := result;
    END;

