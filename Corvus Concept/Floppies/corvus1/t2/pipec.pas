{ File ID: PIPEC.PAS }

{
  This file contains the declarations and routines that are specific
  to the CP/M enviroment.
}


EXTERNAL PROCEDURE  SEND (VAR DB: CorvusRec);
EXTERNAL PROCEDURE  RECV( VAR DB: CorvusRec);
   
PROCEDURE pmodinit;
  BEGIN
    initnames := 'WOOFW00FF00WFOOW';
  END;

FUNCTION INT(wd: WORD): INTEGER;
    {---------------------------------------------------}
    { int - returns the integer value of a WORD		}
    { watch out for negative integers			}
    {---------------------------------------------------}
  BEGIN
    INT := 256*ORD(wd.hi) + ORD(wd.lo);
  END;

     
    {***************************************************************}
    { result - sends the command in pbuf to the drive and receives  }
    { the results.... all pipe or disk errors are converted to      }
    { negative numbers here....                                     }
    { **************************************************************}
FUNCTION result: INTEGER;
  BEGIN
    SEND(reqbuf);
    RECV(repbuf);
    IF ORD(repbuf.rply.dcode) < 128 THEN
      result := ORD(repbuf.rply.ppcode) * (-1)
    ELSE
      result := ORD(repbuf.rply.dcode) * (-1);
  END;
     
 FUNCTION pipewrite(npipe, wlen: INTEGER; info: BLOCK): INTEGER;  
     { **************************************************************** }
     { FUNCTION pipewrite(npipe, wlen: INTEGER; info: BLOCK): INTEGER;  }
     { Write wlen bytes to pipe number npipe.  0 < wlen <= 512          }
     { Returns the number of bytes written or an error code.            }
     { **************************************************************** }
  VAR
     num: INTEGER;
  BEGIN
    WITH reqbuf, rqst DO
    BEGIN
      size := CHR(FiveByte);
      command := CHR(Wrt);
      pipenum := CHR(npipe);
    END; {WITH}
		{ In order to pack this record (since prd/pwrt.len is
		  on an odd address) we use arrays
		}
    reqbuf.arr[3] := CHR(wlen MOD 256);	{ low byte of length field }
    reqbuf.arr[4] := CHR(wlen DIV 256);	{ HIBYTE OF LENGTH }
    reqbuf.LLEN := wlen+5;
    MOVELEFT(info[0], reqbuf.arr[5], wlen);
    repbuf.llen := 12;
    num := result;
    IF num = 0 THEN 
      pipewrite := INT(repbuf.rply.len)
    ELSE
      pipewrite := num;
  END; {pipewrite}
{$P}

 FUNCTION piperead(npipe: INTEGER; VAR info: BLOCK): INTEGER;
      { ************************************************************** }
      { FUNCTION piperead(npipe: INTEGER; VAR info: BLOCK): INTEGER;   }
      { Read upto 512 bytes from pipe npipe.                           }
      { Returns number of bytes read or error code.....                }
      { ************************************************************** }
  VAR
    limit: INTEGER;
  BEGIN
    WITH reqbuf,rqst DO
    BEGIN
      size := CHR(FiveByte);
      command := CHR(Rd);
      pipenum := CHR(npipe);
      {len.LO := 0;
       len.HI := 2;} { len = 200hex = 512 }
    END; {WITH}
		{
		 Using array in order to pack this record since
		 prd/pwrt.len is on an odd address
		}
    reqbuf.int[3] := CHR(0);
    reqbuf.int[4] := CHR(2); {using arrays because of Pascal bug!!!}
    reqbuf.LLEN := 5;
    repbuf.llen := 516;
    limit := result;
    IF limit = 0 THEN 
      BEGIN
        limit := INT(repbuf.rply.length);
        MOVELEFT(repbuf.arr[4],info, limit);
      END;
    piperead := limit;
  END; {piperead}
