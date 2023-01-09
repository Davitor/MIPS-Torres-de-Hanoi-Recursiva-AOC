.data

titulo: .asciiz		"---- Torre de Hanói ----\nQuantidade de discos: "
mover: .asciiz		"\nMove disco "
de: .asciiz		" de "
para: .asciiz		" para "

.text
	.globl main
main:

    li $v0,  4          # print string
    la $a0,  titulo
    syscall
    li $v0,  5          # leitura de int
    syscall
    move    $a0, $v0	# entrada em a0 (núm de discos)
    li $a1, 'A'		# Pino A (origem)
    li $a2, 'B'		# Pino B (destino)
    li $a3, 'C'		# Pino C (aux)

    jal hanoi           # chama funçao

    li $v0, 10          # termina a execuçao do programa
    syscall

hanoi:

    addi $sp, $sp, -20	# Ajusta a pilha (stack) com espaço para 5 itens
    sw   $ra, 0($sp)	# Guarda o endereço de retorno (return address)
    
    # Armazenamento de espaços para os parametros:
    sw   $s0, 4($sp)
    sw   $s1, 8($sp)
    sw   $s2, 12($sp)
    sw   $s3, 16($sp)
    
    # Transfere os valores dos parametros para os espaços na função
    move    $s0, $a0	# Numero de discos
    move    $s1, $a1	# Pino de Origem
    move    $s2, $a2	# Pino de Destino
    move    $s3, $a3	# Pino auxiliar

    addi $t1, $zero, 1
    beq $s0, $t1, imprime	# Se s0 = 1 é o caso base, numero de discos = 1 vai para "imprime"

    recursao1:

        addi $a0, $s0, -1	# Subtrai 1 disco (desce 1 nivel na recursão) e chama a funçao novamente
        
        # Inverte os valores dos pinos de destino e do auxiliar
        move $a1, $s1
        move $a2, $s3	
        move $a3, $s2
        jal hanoi

        j imprime 

    recursao2:

        addi $a0, $s0, -1	# Subtrai 1 disco (desce 1 nivel na recursão) e chama a funçao novamente
        
        # Inverte os valores dos pinos de origem e do auxiliar
        move $a1, $s3
        move $a2, $s2
        move $a3, $s1
        jal hanoi

    exithanoi:

        lw   $ra, 0($sp)        # Recupera os registradores da pilha
        lw   $s0, 4($sp)
        lw   $s1, 8($sp)
        lw   $s2, 12($sp)
        lw   $s3, 16($sp)
        addi $sp, $sp, 20       # Restauração do espaço da pilha
        jr $ra			# Retorna a linha onde a funçao foi chamada

    imprime:
	# Imprime o movimento a ser realizado no passo atual
        li $v0,  4              # print string
        la $a0,  mover
        syscall
        li $v0,  1              # print int
        move $a0, $s0
        syscall
        li $v0,  4              # print string
        la $a0,  de
        syscall
        li $v0,  11             # print char
        move $a0, $s1
        syscall
        li $v0,  4              # print string
        la $a0,  para
        syscall
        li $v0,  11             # print char
        move $a0, $s2
        syscall

        beq $s0, $t1, exithanoi	# Se houver 1 disco (caso base) sai da funçao
        j recursao2		# Retorna a segunda chamada da recursao
