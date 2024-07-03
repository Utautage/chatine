'  
'                                
'                             
'           
'                     
'        
'                   
'             
'                    
'          
'                                        
'    
'                                        
'                                        
'                                        
'
ACLS:XSCREEN 1:SYSBEEP=0
'--------------------
DIM XFL$[0],FL$[0],SAV[0],MPNM$[0],MPSD$[0]
'===================================
BACKCOLOR #LIME
GPUTCHR3 345,232,"Ver 1.0.0",1,1,-1,-2
FOR I=0 TO 255 STEP 10
 GPUTCHR3 136,107,"Chatine",3,3,RGB(I,255,I),-6
 VSYNC
NEXT
VSYNC 60
'===================================
RESTORE @CHRDATA
DIM F$[4]
FOR J=0 TO 7
 READ H$
 FOR I=0 TO 3
  FOR H=0 TO 7
   F$[I]=F$[I]+H$[I*8+H]*4
  NEXT
 NEXT
NEXT
FONTDEF ASC(""),F$[0]
FONTDEF ASC(""),F$[1]
FONTDEF ASC(""),F$[2]
FONTDEF ASC(""),F$[3]
'--------------------
@CHRDATA
DATA"0FFF000FF000000000000F000000F000"
DATA"F000F000F000000000000F0000FFF000"
DATA"F0000000F0000FFF000FFFFF0000F000"
DATA"0FFF0000F000F000F0000F000000F000"
DATA"0000F000F000F000F0000F000000F000"
DATA"F000F000F000F000F0000F000000F000"
DATA"0FFF000FFF000FFF000000FF00FFFFF0"
DATA"00000000000000000000000000000000"
'===================================
BACKCOLOR #BLACK
GCLS
CLS
COLOR 13
?"Hardware checking... "
FOR I=0 TO 24
 ?"";
 VSYNC
NEXT
IF HARDWARE==2 THEN
 BEEP 2
 COLOR 3:???"Hardware Error!":?"Wireless communication is not avalable on the WiiU"
 COLOR 7
 ??"Press  to End"
 REPEAT:UNTIL BUTTON(2) AND #A
 SYSBEEP=1
 END
ENDIF
VSYNC 30
'--------------------
???"Slot1 deleteing... "
PRGEDIT 1
PRGDEL -1
IF !RESULT THEN
 BEEP 2
 COLOR 3:??"Deletion Error!":?"Deletion of the contents of  has been canceled"
 COLOR 7
 ??"Press  to End"
 REPEAT:UNTIL BUTTON(2) AND #A
 SYSBEEP=1
 END
ENDIF
FOR I=0 TO 199
 LOCATE 0,4
 ?""*(I/4);CHR$(58025+(I MOD 4)*2)
 VSYNC
NEXT
VSYNC 30
'--------------------
??"File checking... "
FOR I=0 TO 49
 ?"";
 VSYNC
NEXT
VSYNC 30
CLS
'===================================
COLOR 1
FONTDEF
FONTDEF ASC(""),("F"*8+"0"*24)*7+"0"*32
IF CHKFILE("DAT:CHATINE.SET") THEN
 LOAD "DAT:CHATINE.SET",SAV,0
 LANG=POP(SAV)
 PF=POP(SAV)
 IF PF==-1 THEN
  PASS$="NONE"
 ELSE
  PASS$=FORMAT$("%04D",PF)
 ENDIF
 FOR I=-2 TO LEN(SAV)
  INC USERNM$,CHR$(SHIFT(SAV))
 NEXT
' LANG=1
 GOTO @START
ENDIF
BACKCOLOR -1
'
@RESET
GPUTCHR 139,111,"使用する言語を選択して下さい。",#BLACK
GPUTCHR3 145,119,"Select a language.",1,1,#BLACK,-2
LANG=DIALOG(CHR$(10)*8+"Japanese"+" "*36+"English",1,"言語の選択 / Language Selection")>=0

'===================================
GCLS
IF LANG THEN
 GPUTCHR3 145,111,"Set the user name.",1,1,#BLACK,-2
 GPUTCHR3 154,119,"("+CHR$(34)+"Yes"+CHR$(34)+"  "+CHR$(34)+"Run"+CHR$(34)+")",1,1,#BLACK,-2
ELSE
 GPUTCHR 147,111,"ユーザー名の設定をします。",#BLACK
 GPUTCHR 155,119,"(「はい」「実行」)",#BLACK
ENDIF

REPEAT
 MPSTART 2,"Chatine_User"
UNTIL MPCOUNT==1
USERNM$=MPNAME$(0)
MPEND
'===================================
@PASSCODE
GCLS
IF LANG THEN
 GPUTCHR3 148,107,"Set the passcode.",1,1,#BLACK,-2
 GPUTCHR3 139,115,"(4 digits by number)",1,1,#BLACK,-2
 GPUTCHR3 22,123,"If you set it to "+CHR$(34)+"NONE"+CHR$(34)+", you can log in without a passcode.",1,1,#BLACK,-2
ELSE
 GPUTCHR 147,107,"パスコードの設定をします。",#BLACK
 GPUTCHR 167,115,"(数字で4ケタ)",#BLACK
 GPUTCHR 91,123,"「NONE」にするとパスコードなしでログインできます。",#BLACK
ENDIF
REPEAT
 IF LANG THEN
  PASS$=DIALOG("","Passcode setting",4)
 ELSE
  PASS$=DIALOG("","パスコードの設定",4)
 ENDIF
UNTIL RESULT==1&&(PASS$=="NONE"||PASS$=="0000"||VAL(PASS$)!=0)&&LEN(PASS$)==4
'===================================
GCLS
IF PASS$!="NONE" THEN
 IF LANG THEN
  GPUTCHR3 37,111,"Please enter the same passcode again for confirmation.",1,1,#BLACK,-2
  GPUTCHR3 97,119,"(We will reconfigure with "+CHR$(34)+"Back"+CHR$(34)+".)",1,1,#BLACK,-2
 ELSE
  GPUTCHR 95,111,"確認のため、もう一度同じパスコードを入力して下さい。",#BLACK
  GPUTCHR 147,119,"(「戻る」でし直します。)",#BLACK
 ENDIF
 REPEAT
  IF LANG THEN
   PASS2$=DIALOG("","Confirm passcode",4)
  ELSE
   PASS2$=DIALOG("","パスコードの確認",4)
  ENDIF
  IF RESULT==-1 THEN @PASSCODE
 UNTIL RESULT==1&&(PASS2$=="0000"||VAL(PASS2$)!=0)&&LEN(PASS2$)==4&&PASS2$==PASS$
ENDIF
'===================================
GCLS
IF LANG THEN
 GPUTCHR3 139,115,"Is this appropriate?",1,1,#BLACK,-2
 D$="Language:English"+CHR$(10)+"Username:"+USERNM$+CHR$(10)+"Passcode:"+"None"*(PASS$=="NONE")+"****"*(PASS$!="NONE")
 C$="Confirm settings"
ELSE
 GPUTCHR 147,115,"この設定でよろしいですか?",#BLACK
 D$="言語:Japanese"+CHR$(10)+"ユーザーネーム:"+USERNM$+CHR$(10)+"パスコード:"+"なし"*(PASS$=="NONE")+"****"*(PASS$!="NONE")
 C$="設定の確認"
ENDIF
IF DIALOG(D$,1,C$)==-1 THEN GCLS:GOTO @RESET
'===================================
GCLS
IF LANG THEN
 GPUTCHR3 112,111,"Account setting is completed.",1,1,#BLACK,-2
 GPUTCHR3 94,119,"In "+CHR$(34)+"Yes"+CHR$(34)+", please save account data.",1,1,#BLACK,-2
ELSE
 GPUTCHR 135,111,"アカウントの設定が完了しました。",#BLACK
 GPUTCHR 107,119,"「はい」で、アカウントデータを保存して下さい。",#BLACK
ENDIF
REPEAT
FOR I=0 TO LEN(USERNM$)-1
 PUSH SAV,ASC(MID$(USERNM$,I,1))
NEXT
IF PASS$=="NONE" THEN
 PUSH SAV,-1
ELSE
 PUSH SAV,VAL(PASS$)
ENDIF
PUSH SAV,LANG
SAVE "DAT:CHATINE.SET",SAV
UNTIL RESULT==1
GOTO @LOGON
'
@START
BACKCOLOR -1:COLOR 1
'===================================
IF PASS$!="NONE" THEN
 SEL=-1
 WHILE 1
  STICK OUT SX,SY
  IF BUTTON(2) AND #X THEN BEEP 29:WATCH=!WATCH
  PW=SQR(SX*SX+SY*SY)*13
  ROT=90-DEG(ATAN(SY,SX))
  SAT 199,119,PW*WATCH,ROT OUT RX,RY
  IF WATCH THEN
   GPUTCT 199,46,PASS2$+"-"*(4-LEN(PASS2$)),4,4,#BLACK
  ELSE
   GPUTCT 199,46,""*LEN(PASS2$)+""*(4-LEN(PASS2$)),4,4,#BLACK
  ENDIF
  IF LANG THEN
   GPUTCHR3 199-(9+LEN(USERNM$))*3,5,"Welcome, "+USERNM$,1,1,#BLACK,-2
   GPUTCHR3 133,13,"Please Enter Passcode.",1,1,#BLACK,-2
   IF WRONG THEN GPUTCHR3 145,60,"Passcode is wrong.",1,1,#RED,-2
   GPUTCHR3 142,203,"  Confirm passcode",1,1,#BLACK,-2
   GPUTCHR3 142,211,"      Quit Chatine",1,1,#BLACK,-2
   GPUTCHR3 142,219,"   Visual ON / OFF",1,1,#BLACK,-2
   GPUTCHR3 142,227," Clear 1 character",1,1,#BLACK,-2
  ELSE
   GPUTCT 199,9,USERNM$+"さん、ようこそ",1,1,#BLACK
   GPUTCHR 143,13,"パスコードを入力して下さい。",#BLACK
   IF WRONG THEN GPUTCHR 155,60,"パスコードが違います。",#RED
   GPUTCHR 143,203,"・・・・・パスコードの確定",#BLACK
   GPUTCHR 143,211,"・Chatineを終了する",#BLACK
   GPUTCHR 143,219,"・・・・目視のON/OFF",#BLACK
   GPUTCHR 143,227,"・・・・・・・・1文字消す",#BLACK
  ENDIF
  GCIRCLE 199,119,30,#BLACK
  GCIRCLE RX,RY,15,#BLACK
  GPAINT RX,RY,#SILVER
  FOR I=0 TO 9
   SAT 199,119,40,I*36 OUT PX,PY
   IF SEL==I&&WATCH THEN
    GCIRCLE PX-1,PY-1,6,#AQUA
    GPAINT PX-1,PY-1,#AQUA
   ENDIF
   GPUTCT PX,PY,STR$(I),1,1,#BLACK
  NEXT
  IF SX!=0||SY!=0 THEN
   FOR SEL=0 TO 9
    ROTH=(ROT+360) MOD 360
    MINR=SEL*36-18
    MAXR=SEL*36+18
    CHK1=ROTH>=MINR
    CHK2=ROTH<MAXR
    CHK3=SEL==0&&ROT>=-18&&ROT<18
    IF (CHK1&&CHK2)||CHK3 THEN BREAK
   NEXT
   IF BSEL!=SEL&&!WATCH THEN BEEP 48,-600,30
  ELSE
   IF SEL!=-1&&LEN(PASS2$)<4 THEN BEEP 27,1000:INC PASS2$,STR$(SEL)
   SEL=-1
  ENDIF
  IF BUTTON(2) AND #A && LEN(PASS2$)==4 THEN
   IF PASS$==PASS2$ THEN
    BEEP 32:BREAK
   ELSE
    BEEP 4:WRONG=1:PASS2$=""
   ENDIF
  ENDIF
  IF BUTTON(2)AND #Y&&LEN(PASS2$)THEN BEEP 27,1000:PASS2$=LEFT$(PASS2$,LEN(PASS2$)-1)
  IF BUTTON(2) AND #B THEN
   BEEP 36
   IF LANG THEN
    A=DIALOG("Do you want to exit Chatine?",1,"Confirmation of termination B Button")
   ELSE
    A=DIALOG("Chatineを終了しますか？",1,"Bボタンによる終了確認")
   ENDIF
   IF A==1 THEN BEEP 37:DISPCLEAR 0:SYSBEEP=1:END
  ENDIF
  VSYNC:GCLS:BSEL=SEL
 WEND
ENDIF
'
@LOGON
SEL=0
PAGE=1
@LOGONC
XFL$=NEW$():FL$=NEW$()
FILES "TXT:",XFL$
FOR I=0 TO LEN(XFL$)-1
 IF RIGHT$(XFL$[I],4)==".CHT" THEN PUSH FL$,LEFT$(RIGHT$(XFL$[I],LEN(XFL$[I])-1),LEN(XFL$[I])-5)
NEXT
MAXPAGE=CEIL(LEN(FL$)/6)
WHILE 1
 GFILL 0,0,399,8,#GRAY
 GPUTCHR3 0,1,"Chatine Ver 1.0.0",1,1,#BLACK,-2
 IF LANG THEN
  GPUTCHR3 159,1," Select  Confirm  End  New Community",1,1,#AQUA,-2
 ELSE
  GPUTCHR 208,1,"選択 決定 終了する 新しいコミュニティ",1,1,#AQUA
 ENDIF
 IF LEN(FL$)==0 THEN
  IF LANG THEN
   GPUTCHR3 12,119,"There are no commyunities to join.",2,2,#BLACK,-5
  ELSE
   GPUTCT 199,119,"参加できるコミュニティはありません",2,2,#BLACK
  ENDIF
 ELSE
  GPUTCT 199,14,""[PAGE==1],1,1,#BLACK
  GPUTCT 199,237,""[PAGE==MAXPAGE],1,1,#BLACK
  FOR I=0 TO 5
   IF (PAGE-1)*6+I==LEN(FL$) THEN BREAK
   IF SEL==I THEN GCOLOR RGB(255,128,0) ELSE GCOLOR #BLACK
   GBOX 1,18+I*36,398,51+I*36
   GBOX 2,19+I*36,397,50+I*36
   GPUTCHR3 2,21+I*36,FL$[(PAGE-1)*6+I],4,4,GCOLORC(),-8
   IF LANG THEN
    GPUTCHR3 296,35+I*36,"Community",2,2,GCOLORC(),-5
   ELSE
    GPUTCHR 300,35+I*36,"コミュニティ",2,2
  ENDIF
   GPUTCHR3 242,35+I*36,".CHT",2,2,GCOLORC(),-4
  NEXT
 ENDIF
 IF BUTTON(2) AND #A THEN BEEP 3:BREAK
 IF BUTTON(2) AND #B THEN
  BEEP 36
  IF LANG THEN
   A=DIALOG("Do you want to exit Chatine?",1,"Confirmation of termination B Button")
  ELSE
   A=DIALOG("Chatineを終了しますか？",1,"Bボタンによる終了確認")
  ENDIF
  IF A==1 THEN BEEP 37:DISPCLEAR 0:SYSBEEP=1:END
 ENDIF
 IF BUTTON(2) AND #X THEN
  IF LANG THEN
   COM$=DIALOG("","Enter Community name.(name.CHT)",10)
  ELSE
   COM$=DIALOG("","コミュニティ名を入力(name.CHT)",10)
  ENDIF
  IF RESULT==1 THEN
   PRGDEL -1
   SAVE "PRG1:"+COM$+".CHT"
   IF RESULT==1 THEN GOTO @LOGONC
  ENDIF
 ENDIF
 IF BUTTON(1) AND #UP && !(PAGE==1 && SEL==0) THEN
  BEEP 48,-600
  DEC SEL
  IF SEL<0 THEN DEC PAGE:SEL=5
 ENDIF
 IF BUTTON(1) AND #DOWN && !(PAGE==MAXPAGE && SEL==(LEN(FL$) MOD 6)-1) THEN
  IF SEL!=5 THEN BEEP 48,-600
  INC SEL
  IF SEL>5 THEN
   IF PAGE!=MAXPAGE THEN INC PAGE:SEL=0:BEEP 48,-600 ELSE SEL=5
  ENDIF
 ENDIF
 VSYNC:GCLS
WEND
PRGDEL -1
LOAD "PRG1:"+FL$[(PAGE-1)*6+SEL]+".CHT",0
MPNM$=NEW$():MPSD$=NEW$()
PRGEDIT 1,1
IF PRGSIZE(1)==2 THEN @CMSKIP
FOR I=1 TO PRGSIZE(1)/2
 PG$=PRGGET$()
 PUSH MPNM$,LEFT$(PG$,LEN(PG$)-1)
 PG$=PRGGET$()
 PUSH MPSD$,LEFT$(PG$,LEN(PG$)-1)
NEXT
@CMSKIP
MAXSC=(LEN(MPSD$)-8)*25-15
IF MAXSC<0 THEN MAXSC=0
SC=MAXSC

'
SEND$=""
'===================================
WHILE 1
 STICK OUT SX,SY:SPD=SPD+SY/5
 IF SY==0 THEN SPD=0
 SC=SC-SPD
 IF SC<0 THEN SC=0
 IF SC>MAXSC THEN SC=MAXSC
'--------------------
 FOR I=0 TO LEN(MPSD$)-1
  IF 10-SC+I*25<-14 THEN CONTINUE
  IF 10-SC+I*25>239 THEN CONTINUE
  ON MPNM$[I]==USERNM$ GOSUB @FUKI0,@FUKI1
 NEXT
'--------------------
 GFILL 0,0,399,8,#GRAY
 GPUTCHR3 0,1,FL$[(PAGE-1)*6+SEL]+".CHT",1,1,#BLACK,-2
 IF MPCOUNT THEN
  IF LANG THEN
   GPUTCHR3 231,1," Scroll  End Communication",1,1,#AQUA,-2
  ELSE
   GPUTCHR 288,1,"スクロール 通信を終える",1,1,#AQUA
  ENDIF
 ELSE
  IF LANG THEN
   GPUTCHR3 177,1," Scroll  Start Communication  Back",1,1,#AQUA,-2
  ELSE
   GPUTCHR 256,1,"スクロール 通信を始める 戻る",1,1,#AQUA
  ENDIF
 ENDIF
 IF BUTTON(2) AND #B THEN
  IF MPCOUNT THEN
   PRGDEL -1
   PRGEDIT 1,1
   FOR I=-1 TO LEN(MPNM$)-1
    IF LEN(MPNM$)==0 THEN BREAK
    PRGINS SHIFT(MPNM$)
    PRGINS SHIFT(MPSD$)
   NEXT
   REPEAT
    SAVE"PRG1:"+FL$[(PAGE-1)*6+SEL]+".CHT"
   UNTIL RESULT==1
   MPEND
   LOAD"PRG1:"+FL$[(PAGE-1)*6+SEL]+".CHT",0
   IF PRGSIZE(1)==2 THEN @CMSKIP2
   PRGEDIT 1,1
   MPNM$=NEW$():MPSD$=NEW$()
   FOR I=1 TO PRGSIZE(1)/2
    PG$=PRGGET$()
    PUSH MPNM$,LEFT$(PG$,LEN(PG$)-1)
    PG$=PRGGET$()
    PUSH MPSD$,LEFT$(PG$,LEN(PG$)-1)
   NEXT
   @CMSKIP2
  ELSE
   BREAK
  ENDIF
 ENDIF
 IF BUTTON(2) AND #X && !MPCOUNT THEN
  MPSTART 4,"Chat_"+FL$[(PAGE-1)*6+SEL]
 ENDIF
 IF MPCOUNT THEN
  GFILL 0,225,399,239,#GRAY
  GFILL 2,227,396,237,#WHITE
  GBOX 2,227,396,237,#BLACK
  GPUTCHR 4,229,SEND$+" "[(LEN(SEND$)<49&&F MOD 60<30)==0],#BLACK
'--------------------
  K$=INKEY$()
  IF K$!="" THEN
   BEEP 9
   IF ASC(K$)==8 THEN
    IF SEND$!="" THEN SEND$=LEFT$(SEND$,LEN(SEND$)-1)
   ELSEIF ASC(K$)==13 THEN
    IF SEND$!="" THEN MPSEND SEND$:SEND$=""
   ELSEIF LEN(SEND$)<49 THEN
    INC SEND$,K$
   ENDIF
  ENDIF
'--------------------
  IF BUTTON(2) AND #A THEN
   BEEP 9
   IF SEND$!="" THEN MPSEND SEND$:SEND$=""
  ENDIF
  IF BUTTON(1) AND #Y THEN
   BEEP 9
   IF SEND$!="" THEN SEND$=LEFT$(SEND$,LEN(SEND$)-1)
  ENDIF
'--------------------
  MPRECV OUT ID,CHK$
  IF ID!=-1 THEN
   BEEP 51,1000
   PUSH MPNM$,MPNAME$(ID)
   PUSH MPSD$,CHK$
   MAXSC=(LEN(MPSD$)-8)*25-15
   IF MAXSC<0 THEN MAXSC=0
   SC=MAXSC
  ENDIF
 ENDIF
 VSYNC:GCLS:INC F
WEND
'--------------------
BEEP 4
WAIT 1
PRGDEL -1
GOTO @LOGONC
'===================================
@FUKI0
 GPUTCHR 1,10-SC+I*25,MPNM$[I],#BLACK
 GBOX2 1,18-SC+I*25,5+LEN(MPSD$[I])*8,30-SC+I*25,5,RGB(178,178,178)
 GPAINT 5,22-SC+I*25,RGB(178,178,178)
 GLINE 3,29-SC+I*25,1,33-SC+I*25,RGB(178,178,178)
 GLINE 1,33-SC+I*25,8,29-SC+I*25,RGB(178,178,178)
 GPSET 2,32-SC+I*25,RGB(178,178,178):GPAINT 4,31-SC+I*25,RGB(178,178,178)
 GPUTCHR 4,21-SC+I*25,MPSD$[I],#BLACK
RETURN
'--------------------
@FUKI1
 GPUTCHR 399-LEN(USERNM$)*8,10-SC+I*25,USERNM$,#BLACK
 GBOX2 394-LEN(MPSD$[I])*8,18-SC+I*25,398,30-SC+I*25,5,#GREEN
 GPAINT 397,23-SC+I*25,#GREEN
 GLINE 396,29-SC+I*25,398,33-SC+I*25,#GREEN
 GLINE 398,33-SC+I*25,389,29-SC+I*25,#GREEN
 GPSET 397,32-SC+I*25,#GREEN:GPAINT 396,31-SC+I*25,#GREEN
 GPUTCHR 397-LEN(MPSD$[I])*8,21-SC+I*25,MPSD$[I],-1
RETURN
'===================================
DEF GPUTCHR3 X,Y,T$,W,H,C,P
 VAR I
 FOR I=0 TO LEN(T$)-1
  GPUTCHR X,Y,MID$(T$,I,1),W,H,C
  X=X+8*W+P
 NEXT
END
'--------------------
DEF GBOX2 X1,Y1,X2,Y2,H,C
 VAR R1,R2,R3,R4,R5,HH
 R1=180:R2=270:R3=0:R4=90:HH=H
 IF H<0 THEN
  R1=0:R2=90:R3=180:R4=270
  H=ABS(H):HH=0
 ENDIF
 GLINE X1+H,Y1,X2-H,Y1,C
 GLINE X1+H,Y2,X2-H,Y2,C
 GLINE X1,Y1+H,X1,Y2-H,C
 GLINE X2,Y1+H,X2,Y2-H,C
 GCIRCLE X1+HH,Y1+HH,H,R1,R2,0,C
 GCIRCLE X2-HH,Y1+HH,H,R2,R3,0,C
 GCIRCLE X1+HH,Y2-HH,H,R4,R1,0,C
 GCIRCLE X2-HH,Y2-HH,H,R3,R4,0,C
END
'--------------------
DEF SAT SX,SY,RD,ROT OUT X,Y
 X=SX-RD*COS(RAD(90+ROT))
 Y=SY-RD*SIN(RAD(90+ROT))
END
'--------------------
DEF GPUTCT X,Y,TX$,SCX,SCY,COL
GPUTCHR X-SCX*4*LEN(TX$),Y-SCY*4,TX$,SCX,SCY,COL
END
'--------------------
DEF DISPCLEAR DISP
 DISPLAY DISP:BACKCOLOR 0:FADE 0:WIDTH 8
 COLOR 15,0:LOCATE 0,0,0:ATTR 0:CLS:GCLS
 GPAGE 0,0:GPRIO 512:SPCLR:BGCLR
 VISIBLE 1,1,1,1
END
'--------------------
DEF NEW$()
 DIM A$[0]
 RETURN A$
END
'--------------------
DEF GCOLORC()
 VAR A
 GCOLOR OUT A
 RETURN A
END
