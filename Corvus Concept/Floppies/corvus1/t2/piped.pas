{ File ID:  piped.pas }

{
  This file contains the declarations for the pipes module.  These
  declarations are common to both the LSI and the CP/M enviroment.
}

CONST
    Pipesversion        = '1.1';
    NameLen             = 8;    {size of a pipe name}
    StringMax           = 85;
    MessageSize         = 520;
    BlockLen            = 512;
    BlockMax		= 511;
    
    OkCode              =  0;   {successful return code}
    
    {pipe error return codes...}
    PEmpty           = -8;   {tried to read an empty pipe}
    PNotOpen         = -9;   {pipe was not open for read or write}
    PFull            = -10;  {tried to  write to a full pipe}
    POpErr           = -11;  {tried to open (for reading) an open pipe}
    PNotThere        = -12;  {pipe does not exist}
    PNoRoom          = -13;  {the pipe data structures are full, and there
                                 is no room for new pipes at the moment...}
    PBadCmd          = -14;  {illegal command}
    PsNotInitted     = -15;  { pipes not initialized }
    {an error code less than -127 is a fatal disk error}

    FiveByte            = 26;   {indicates a four byte opcode 1Ah}
    TenByte             = 27;   {ten byte opcode... 1Bh}
  
    {the following constants are used to select the type of request}
    OpnRd               = 192;  {open pipe for read}
    OpnWt               = 128;  {open for write}
    Rd                  = 32;   {read pipe}
    Wrt                 = 33;   {write pipe}
    Close               = 64;   {close read or close write}
    Status              = 65;   {pipe status command}
    PInit               = 160;  {initialize the pipes...}
    
    {pipe state constants...}
    ClsWt               = 254;
    ClsRd               = 253;
    Purge               = 0;


TYPE
    BLOCK = PACKED ARRAY[0..BlockMax] OF CHAR;
    
    buff = PACKED ARRAY [0..1030] OF CHAR;
    
    word = PACKED RECORD
           lo: CHAR;
           hi: CHAR;
           END; {word}
    
    kind = (closes, prd, pwrt, pint, opens, stat);
    
    pipename = PACKED ARRAY[1..NameLen] OF CHAR;
    
    request = PACKED RECORD
              size: CHAR;
              command: CHAR;
              CASE kind OF
                    opens: (name: pipename);
                   closes: (pipeno: CHAR;
                             state: CHAR);
                prd, pwrt: (pipenum: CHAR;
                                len: word);
                     pint: (addr: word;
                            bufsize: word);
		     stat: (statyp: CHAR);
              END; {request}
             
    reply = PACKED RECORD
            dcode: CHAR;
            ppcode: CHAR;
            CASE kind OF
              opens: (pipeno: CHAR;
                      state: CHAR);
              pwrt:  (len: word);
              prd:   (length: word;
                      rdata: block)
            END; {reply}
    
    CorvusRec = RECORD
                llen: INTEGER;
                CASE INTEGER OF
                   1: (rqst: request);
                   2: (rply: reply);
                   3: (arr: buff);
                   4: (int: PACKED ARRAY[0..530] OF CHAR);
                END;
     
     lit = PACKED ARRAY [1..16] OF CHAR;

VAR
    reqbuf,repbuf: CorvusRec;
    initnames: STRING;
