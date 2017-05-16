model small

.data
	mes2 db 'this is thoughts', 10, 13,'$'		;исходная строка, описанная в дата сегменте
	mes1 db 'Input symbol for substitution on zero: $' ;сообщения для интерфейса проги
	textB db 'Text before changing: $'
	textA db 'Text after changing: $'
	blank db '', 10, 13, '$'
	simvol db '0'					;символ на который будем изменять найденные символы
	mes dw ?						
.stack 100h

.code
ASSUME     ds:@data,es:@data
	start:
		mov ax, @data
		mov ds, ax
		mov es, ax
		
		mov mes, offset textB 		
		call far ptr ShowMess
		
		mov mes, offset mes2 
		call far ptr ShowMess
		
		mov mes, offset mes1 
		call far ptr ShowMess
		
		call far ptr ScanAndReplace ;вызов процедуры поиска и замены на 0 всех совпадений
		
		mov mes, offset blank
		call far ptr ShowMess
		
		mov mes, offset textA 
		call far ptr ShowMess
		
		mov mes, offset mes2
		call far ptr ShowMess
		
		call far ptr Endprog
		
		ScanAndReplace proc far
			mov ah,01h
			int 21h 				;ввод символа,вызов 1 процедуры прерывания дос
			cld 					;устанавливаем направление сканировани
			lea di, mes2
			mov bx, offset mes1 	;смещение строки в дата сегменте следующей за нашей строкой
			dec bx 					;отнимаем символ бакса
			mov cx, bx
			next:
			scasb 					;сканируем строку посимвольно
			je findS				; переход при совпадении значений в al и di
			jcxz endOfStr 			;переход при cx=0
			jmp notFindS
			findS:
			mov bl,[simvol] 
			mov [di-1],bl			;замена найденного символа на 0
			dec cx
			jmp next				;просканируем строку еще раз в поисках очередного совпадения
			notFindS:
			dec cx
			jmp next				;просканируем строку еще раз в поисках очередного совпадения
			endOfStr:		
			ret
		ScanAndReplace endp
		
		ShowMess proc far			;процедуры вывода сообщений на экран
			mov dx, mes
			mov ah,09
			int 21h
			ret
		ShowMess endp
		
		Endprog proc far
			mov ah, 01h 	;прерывание дос на ожидание любого дествия с клавиатуры
			int 21h
			mov ah, 4Ch 	;прерывание дос на завершение программы
			int 21h	
		Endprog endp
	end start