include mymacros.inc
.model small
.stack 64
.data
mes db 'This is a message','$' 
MesWith2LinesAndTab db 'The first Line',10,13,'The second Line ',9,'After tab','$'
InDATA db 30,?,30 dup('$') ;First byte is the size, second byte is the number of characters from the keyboard
MyBuffer LABEL BYTE
BufferSize db 30
ActualSize db ?
BufferData db 30 dup('$')
test dw 9
test2 dw 8
.code         
main proc far             
mov ax,@data
mov ds,ax               

mov ax,0
int 33h;AX=FFFF if there is a mouse attached

mov ax,1;Show the mouse (AX=2:Hide the mouse)
int 33h

mov SI,1;200d
mov ax,3;Get mouse position in CX,DX- BX:Button status 
MPos:int 33h 
dec SI
jnz MPos     

;mov ax,4;Set mouse position by CX,DX
;int 33h 


mov ah, 9
mov dx, offset mes;Display string 
int 21h           ;DOS INT
                  
mov ah,2          ;Display Char
mov dl,'$'
int 21h


mov ah,2          ;Or make a bell sound
mov dl,7
int 21h

       
mov ah,2          ;Move Cursor
mov dx,0A0Ah      ;X,Y Position
int 10h           ;BIOS INT

mov ah, 9
mov dx, offset MesWith2LinesAndTab;Display string 
int 21h     
             
             
mov ah, 9
mov dx, offset mes;Display string in the new location
int 21h              

mov ah,3h         ;Get Cursor position (Saved in DL,DH)
mov bh,0h
int 10h                 

mov ah,07         ;Read one char and put in al without echo
int 21h                  
                  
mov ah,0AH        ;Read from keyboard
mov dx,offset InDATA                  
int 21h         
                

mov ah,2          ;Move Cursor
mov dx,1010h      ;X,Y Position
int 10h    

mov dx, offset InDATA+2;Display the input data in a new location
mov ah, 9
int 21h 

mov ah,0AH        ;Read from keyboard
mov dx,offset MyBuffer                  
int 21h         

mov ah,2          ;Move Cursor
mov dx,1110h      ;X,Y Position
int 10h    

mov dx, offset BufferData;Display the input data in a new location
mov ah, 9
int 21h        

ShowMessage mes   ;Show message by macro  
ShowThreeTimes mes;  

        mov ah,0
        int 16h   ;Get key pressed (Wait for a key-AH:scancode,AL:ASCII)

CHECK:  mov ah,1
        int 16h   ;Get key pressed (do not wait for a key-AH:scancode,AL:ASCII)
        jz CHECK
        
       
        

mov ah,07         ;Read one char and put in al
int 21h       

mov ah,07         ;Read one char and put in al
int 21h 

mov ah,9          ;Display
mov bh,0          ;Page 0
mov al,44h        ;Letter D
mov cx,5h         ;5 times
mov bl,0f9h        ;Green (A) on white(F) background
int 10h

    

                  
mov ax,0600h      ;Scroll Screen AH=06 (Scroll),AL=0 Entire Page
mov bh,07         ;Normal attributes
mov cx,0          ;from 0,0
mov dx,024fH      ;To 02h,4fh
int 10h           ;Clear the first line
              
mov ax,0600h      ;Scroll Screen AH=06 (Scroll),AL=0 Entire Page
mov bh,07         ;Normal attributes
mov cx,0          ;from 0,0
mov dx,184FH      ;To 18h,4fh
int 10h           ;Clear Screen


mov ah,0          ;Change video mode (Graphical MODE)
mov al,13h        ;Max memory size 16KByte
                  ;AL:4 (320*200=64000 [2 bits for each pixel,4 colours])
                  ;AL:6 (640*200=128000[1 bit  for each pixel,2 colours B/W])
int 10h


mov cx,0         ;Column
mov dx,50        ;Row       
mov al,0fh         ;Pixel color
mov ah,0ch       ;Draw Pixel Command
back:   int 10h 
        inc cx
        cmp cx,320
        jnz back 
        
        
mov ah,0          ;Change video mode (Text MODE)
mov al,03h
int 10h 

mov ah, 9
mov dx, offset mes;Display string in the new location
int 21h                  

hlt 
main endp 

end main 


