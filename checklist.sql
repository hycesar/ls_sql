/*
CHECKLIST STATUS:
	41/41	SQL BASICAS
	6/6		SQL AVANÇADAS
	39/39	PL BASICA
	5/5	PL AVANÇADAS
	TOTAL:	91/91
*/

/*
*
*
*
SQL BASICAS
*
*
*
*/

/*
1. Uso de BETWEEN com valores numéricos
*/
SELECT CPF
FROM Salario
WHERE ValorBruto BETWEEN 1000 AND 5000;

/*
2. Uso de BETWEEN com datas
*/
SELECT Nome, CPF
FROM Funcionario
WHERE DataNasce BETWEEN '1992-01-01' AND '1995-01-01';
/*pt-BR*/
SELECT Nome, CPF
FROM Funcionario
WHERE DataNasce BETWEEN '01-01-1992' AND '01-01-1995';

/*
3. Uso de LIKE/NOT LIKE com tokens
*/
SELECT Nome, CPF
FROM Funcionario
WHERE Nome LIKE '%Silva%';

/*
4. Uso de IN com subconsulta
*/
SELECT Nome, CPF
FROM Funcionario
WHERE CPF IN (2222211111, 5675243908);

/*
5. Uso de IS NULL/IS NOT NULL
*/
SELECT Nome, CPF
FROM Funcionario
WHERE CPF IS NOT NULL;

/*
6. Uso de ORDER BY
*/
SELECT Nome, CPF
FROM Funcionario
ORDER BY Nome;

/*
7. Criação de VIEW
--RETORNA UMA VIEW COM TODOS FuncionarioS DO SEXO MASCULINO
*/
CREATE OR REPLACE VIEW view_Funcionario_Homens AS
SELECT Nome, CPF
FROM Funcionario
WHERE Sexo LIKE 'M' OR Sexo LIKE 'Masculino';

/*
8. Consulta sobre VIEW
*/
SELECT Nome
FROM view_Funcionario_Homens;

/*
9. Deleção de VIEW
*/
DROP VIEW view_Funcionario_Homens;

/*
10. Criar CHECK s
*/
--FEITO NA CRIAÇÃO

/*
11. Criar PK Composta
*/
--FEITO NA CRIAÇÃO

/*
12. Criar FK Composta
*/
--FEITO NA CRIAÇÃO

/*
13. Usar Valor DEFAULT (Ex: Data do Sistema)
*/
SELECT Nome
FROM Funcionario
WHERE DataNasce < SYSDATE;

/*
14. Usar ALTER TABLE para Modificação de Coluna
*/
ALTER TABLE Funcionario
MODIFY Numero VARCHAR(13);

/*
15. Usar ALTER TABLE para Adicionar Coluna
*/
ALTER TABLE Funcionario
ADD (SINDICALIZADO CHAR(1));

/*
16. Usar ALTER TABLE para Remover de Coluna
*/
ALTER TABLE Funcionario
DROP (SINDICALIZADO);

/*
17. Operadores aritméticos no SELECT
AUMENTO DE 2x PARA QUEM TEM SALARIO MENOR DE 900
*/
SELECT CPF,(ValorBruto*2.00) AS salario_novo
FROM Salario
WHERE ValorBruto <= 900;

/*
18. Função de agregação sem GROUP BY
CONSULTA DO Funcionario MAIS VELHO
*/
SELECT Nome
FROM Funcionario
WHERE DataNasce IN (SELECT MIN(DataNasce) FROM Funcionario);

/*
19. Função de agregação com GROUP BY
VER QUANDO FuncionarioS HOMENS E MULHRES TEM
*/
SELECT Sexo,COUNT(*)
FROM Funcionario
GROUP BY Sexo;

/*
20. Uso de DISTINCT
--Retorna os cpf dos Funcionarios que possuem Telefone
FAZ-SE CONSULTA DE TODOS OS SEXOS DISTINTOS
*/
SELECT DISTINCT Sexo
FROM Funcionario;

/*
21. Uso de HAVING
-- OQ ESSA CONSULTA FAZ?
--RETORNA TODOS OS CPF DE FuncionarioS QUE TEM MAIS DE UM TELEFONE
*/
SELECT CPF,COUNT(*)
FROM Telefone
GROUP BY CPF
HAVING COUNT(*) > 1;

/*
22. Uso de HAVING com subconsulta
FAZ CONSULTA NA TABELA Funcionario,
QUE RETORNA Nome E SEXO DOS FuncionarioS QUE PERTENCEM AO GRUPO QUE TENHA MAIS DE 1 PESSOA DO MESMO SEXO
*/
SELECT Nome, SEXO
FROM Funcionario
WHERE SEXO IN (SELECT SEXO
	FROM Funcionario
	GROUP BY SEXO
	HAVING COUNT(*) > 1
);

/*
23. Uso de WHERE + HAVING
FEITO NO ITEM ANTERIOR
*/

/*
24. Junção entre duas tabelas
--RETORNA O Nome E O TELEFONE DOS FuncionarioS
*/
SELECT F.Nome,T.Telefone
FROM Telefone T, Funcionario F
WHERE F.CPF = T.CPF;

/*
25. Junção entre três tabelas + condição de seleção (M:N)
RETORNA OS Funcionario com respectivos nome, telefone e valor bruto do salario
*/
SELECT F.Nome, T.Telefone, S.ValorBruto
FROM Salario S, Telefone T, Funcionario F
WHERE F.CPF = T.CPF AND T.CPF = S.CPF;

/*
26. Junção usando INNER JOIN
EXIBE O Nome E A data do salario DOS Funcionario
*/
SELECT F.Nome AS Nome, T.DataSalario AS DataSalario
FROM Funcionario F
INNER JOIN Salario T ON F.CPF = T.CPF;

/*
27. Junção usando LEFT OUTER JOIN
--TODOS TELEFONES DOS Funcionario.. ATE Funcionarios sem telefone
*/
SELECT F.Nome AS Nome,T.Telefone AS Telefone
FROM Funcionario F
LEFT JOIN Telefone T ON T.CPF = F.CPF;

/*
28. Junção usando RIGHT OUTER JOIN
TODOS FuncionarioS Q TEM Telefone
*/
SELECT F.Nome AS Nome,T.Telefone AS TelefoneS
FROM Funcionario F
RIGHT JOIN Telefone T ON T.CPF = F.CPF;

/*
29. Junção usando FULL OUTER JOIN
RETORNA TODOS OS TEMAS DOS PROJETOS REFERENTE A UM funcionario
*/
SELECT P.Tema AS TEMA
FROM Projeto P
FULL OUTER JOIN Funcionario F ON F.CPF = P.CPF;

/*
30. Uma subconsulta com uso de ANY ou SOME
RETORNA OS NomeS DOS FuncionarioS QUANDO O CPF É IGUAL A DE ALGUM Cliente
OBS:. o Funcionario atende o cliente
*/
SELECT F.Nome, F.CPF
FROM Funcionario F
WHERE F.CPF = ANY
	(SELECT CPF
		From Cliente
);

/*
31. Uma subconsulta com uso ALL
A funcionaria mais velha
*/
SELECT Nome
FROM Funcionario
WHERE DataNasce > ALL(SELECT DataNasce FROM Funcionario WHERE SEXO = 'F');

/*
32. Uma subconsulta com uso DE EXISTS/NOT EXISTIS
Retorna um equipamento que já tenha sido usado
*/
SELECT CodigoEquipamento
FROM Equipamento E
WHERE EXISTS (SELECT CodigoEquipamento
	FROM Realiza R
	WHERE R.CodigoEquipamento = E.CodigoEquipamento);

/*
33. Uma subconsulta com uso DE ALIAS
Seleciona o nome com o valor de imposto que cada funcionario paga
*/
SELECT
	F.Nome,
	(SELECT ValorImposto FROM Salario S WHERE S.CPF = F.CPF) AS Imposto
FROM
	Funcionario F

/*
34. USO DE UNION
Selecione as funcionarias E UNI COM os funcionarios que moram em casa com numero 13
*/
SELECT Nome
FROM Funcionario
WHERE Sexo < 'F'
UNION
SELECT Nome
FROM Funcionario
WHERE Numero = '13';

/*
35. USO DE INTERSECT
SELECIONA OS CPF DOS LEITURISTAS
*/
SELECT CPF
FROM Funcionario
INTERSECT
SELECT CPF
FROM Leiturista;

/*
36. USO DE INTERSECT
SELECIONA OS CPF DOS FUNCIONARIOS QUE NAO E LEITURISTA
*/
SELECT CPF
FROM Funcionario
MINUS
SELECT CPF
FROM Leiturista;

/*
37. INSERT COM SUBCONSULTA
INSERE FUNCIONARIO NA TABELA DE LEITURISTA
*/
INSERT INTO Leiturista (CPF)
SELECT f.CPF
FROM Funcionario f
WHERE ROWNUM < 2 AND NOT EXISTS (SELECT CPF FROM LEITURISTA l WHERE f.CPF = l.CPF);

/*
38. INSERT COM SUBCONSULTA
ATUALIZA O NUMERO DE TODOS FUNCIONARIOS PARA A MÉDIA
*/
UPDATE Funcionario
SET Numero = (SELECT AVG(Numero) FROM Funcionario);

/*
39. DELET COM SUBCONSULTA
DELETA O FUNCIONARIO QUE MORA NA RUA ARGENTINA
*/
DELETE FROM Funcionario
WHERE CPF = (SELECT CPF FROM Funcionario WHERE Rua = 'Rua Argentina');

/*
40. USO DE GRANT
CRIAMOS UM USUARIO CHAMADO MATHEUS E GARANTIMOS A ELE O DIREITO DE USAR O SELECT EM FUNCIONARIO
*/
CREATE USER MATHEUS IDENTIFIED BY TRICOLOR;
/
GRANT SELECT ON Funcionario TO MATHEUS;
/

/*
*
*
*
SQL AVANÇADAS
*
*
*
*/

/*41. USO DE REVOKE
TIRAMOS O DIREITO DE MATHEUS USAR O SELECT NA TABELA FUNCIONARIOS
*/
REVOKE SELECT ON Funcionario FROM MATHEUS;
/
DROP USER Funcionario;
/

/*42. SUBCONSULTA EM UM FROM
segunda filtragem
*/
SELECT nome
	FROM (SELECT CPF, nome
		FROM Funcionario
		WHERE Sexo = 'M');

/*43. Operação aritmética com função de agregação como operador
QUANTO FICARIA DE CUSTO PARA EMPRESA APÓS AUMENTO DE 5% FIRMADO PELO SINDICATO?
*/
SELECT SUM(ValorBruto) * 1.05
FROM Salario;

/*44. Uso de BETWEEN com valores numéricos retornados por funções de agregação
QUAL O CPF DOS FUNCIONÁRIOS CUJO SALÁRIO ESTÁ ENTRE O MENOR E A MÉDIA?
*/
SELECT CPF
FROM Salario
WHERE ValorBruto BETWEEN
	(SELECT MIN(ValorBruto) FROM Salario)
	AND
	(SELECT AVG(ValorBruto) FROM Salario);

/*
45. Junção entre três tabelas usando INNER JOIN ou OUTER JOIN
RETORNA O NOME DO FUNCIONARIO, SALARIO BRUOTO E TELEFONE
*/
SELECT F.Nome, S.ValorBruto, T.Telefone
FROM Funcionario F
INNER JOIN Salario S ON S.CPF = F.CPF
INNER JOIN Telefone T ON T.CPF = F.CPF;

/*
46. ORDER BY com mais de dois campos
RETORNA O NOME DO FUNCIONARIO, SALARIO BRUOTO E TELEFONE
*/
SELECT F.NOME, S.ValorBruto, T.Telefone
FROM Funcionario F, Salario S, Telefone T
WHERE F.CPF = S.CPF AND S.CPF = T.CPF
ORDER BY F.NOME, S.ValorBruto, T.Telefone;


/*
47. EXISTS com mais de uma tabela, sem fazer junção
RETORNA OS SALARIOS DE UM FUNCIONARIO SE EXISTIR
*/
SELECT F.CPF
FROM Funcionario F
WHERE EXISTS
	(SELECT S.CPF
	 From Salario S
	 Where S.CPF = F.CPF);

/*
*
*
*
PL BASICAS
*
*
*
*/

/*
48. Bloco anônimo com declaração de variável e instrução
ALTERA SALARIO DE TODOS OS FUNCIONÁRIOS QUE GANHAM MENOS DE 1000
*/
DECLARE
SALARIO_NOVO INT := 2000;
BEGIN
	UPDATE Salario
	SET ValorBruto = SALARIO_NOVO
	WHERE ValorBruto < 1000;
END;

/*
49. Bloco anônimo com declaração de variável e instrução
Trata erro de divisao de um numero
*/
DECLARE
var1 NUMBER;
BEGIN
	var1 := 2/0;
EXCEPTION
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('ERRO: DIVISAO POR ZERO');
end;

/*
50. Uso de IF­THEN­ELSE

51. Uso de ELSIF
MESMA COISA DO ITEM ANTERIOR SENDO COM UM ELSIF
*/
CREATE OR REPLACE PROCEDURE salarioMaiorAvg (fSalario IN Salario.ValorBruto%TYPE) AS
	avgSalario Salario.ValorBruto%TYPE;
BEGIN
	SELECT AVG(ValorBruto) INTO avgSalario
	FROM Salario;

	IF (fSalario <= avgSalario) THEN DBMS_OUTPUT.PUT_LINE('deve receber aumento!');
		ELSIF (fSalario > avgSalario AND fSalario < 2000) THEN DBMS_OUTPUT.PUT_LINE('dever receber metade do aumento');
	ELSE DBMS_OUTPUT.PUT_LINE('nao dever receber aumento');	
	END IF;
END;

/*
52. Uso de CASE
*/
SELECT F.Nome,
	(CASE WHEN F.Sexo LIKE 'M' THEN 'MASCULINO'
				ELSE 'FEMININO'
END) AS SEXO
FROM
	Funcionario F;

/*
53. LOOP com instrução de saída
*/
DECLARE
	counter NUMBER;
	numSoma NUMBER;
BEGIN
	counter := 0;
	LOOP
		SELECT COUNT(*) INTO numSoma
		FROM Salario
		WHERE ValorBruto <= 1000;
		EXIT WHEN counter > 10;
		counter := counter + numSoma;
		counter := counter + 1;		
	END LOOP;
END;

/*
54. WHILE LOOP
*/
CREATE OR REPLACE PROCEDURE testeloop (fSalario IN Salario.ValorBruto%TYPE) AS
	avgSal Salario.ValorBruto%TYPE;
BEGIN
	SELECT AVG(ValorBruto) INTO avgSal
	FROM Salario;

	WHILE avgSal < 2000 LOOP
		avgSal := avgSal + 2;
	END LOOP;
END;

/*
55. FOR LOOP
*/
CREATE OR REPLACE PROCEDURE maisQueMediaSalarial AS
	CURSOR c1 IS
		SELECT ValorBruto
		FROM Salario;
	qntSalarios NUMBER;
	media Salario.ValorBruto%TYPE;
	sal NUMBER;
	acima NUMBER;
BEGIN
	SELECT COUNT(*) INTO qntSalarios
	FROM Salario;
	
	SELECT AVG(ValorBruto) INTO media
	FROM Salario;
	
	OPEN c1;
	acima := 0;
	FOR i IN 0 .. qntSalarios LOOP
		FETCH c1 INTO sal;
		EXIT WHEN c1%NOTFOUND;
			IF sal > media THEN
				acima := acima + 1;
			END IF;
	END LOOP;
	CLOSE c1;
END;

/*
56. Recuperação de dados para variável
*/
DECLARE NFUNC2 NUMBER;
BEGIN
	SELECT COUNT(*) INTO NFUNC2
	FROM Funcionario;
END;
	

/*
57. Recuperação de dados para registro
SATISFEITO No ITEM 50, 51, 52
*/


/*
58. Output de string com variável
*/
DECLARE NFUNC NUMBER;
BEGIN
	SELECT COUNT(*) INTO NFUNC
	FROM Funcionario;		
	DBMS_OUTPUT.PUT_LINE('Numero de funcionarios: ' || TO_CHAR(NFUNC));
END;

/*
59. Uso de cursor explícito com variável
*/
DECLARE
	CURSOR Cursor_pesquisa IS SELECT Nome, CPF FROM funcionario;
	CPFF funcionario.cpf%TYPE;
	NomeF funcionario.nome%TYPE;
BEGIN
	OPEN Cursor_pesquisa ;
	FETCH Cursor_pesquisa INTO NomeF,CPFF;
	DBMS_OUTPUT.PUT_LINE (NomeF || ' ' || CPFF);
END;

/*
60. Uso de cursor explícito com registro
*/
DECLARE
	CURSOR Cursor_pesquisa IS SELECT nome, cpf FROM funcionario ;
	Registro_pesquisa Cursor_pesquisa%ROWTYPE;
BEGIN
	OPEN Cursor_pesquisa;
	LOOP
		FETCH Cursor_pesquisa INTO Registro_pesquisa;
		EXIT WHEN Cursor_pesquisa%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(Registro_pesquisa.Nome || ' ' || Registro_pesquisa.cpf);
	END LOOP;
	CLOSE Cursor_PESQUISA;
END;

/*
61. Uso de cursor explícito com parâmetro
*/
DECLARE
	CURSOR Cursor_pesquisa (CPFF NUMBER) IS SELECT Cpf, Nome FROM funcionario WHERE CPF = CPFF;
	Registro_pesquisa Cursor_pesquisa%ROWTYPE;
BEGIN
	OPEN Cursor_pesquisa ('1111');
	LOOP
		FETCH Cursor_pesquisa INTO Registro_pesquisa;
		EXiT WHEN Cursor_pesquisa%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(Registro_pesquisa.CPF || ' ' ||Registro_pesquisa.Nome);
	END LOOP;
	CLOSE Cursor_pesquisa;
END;

/*
62. Cursor dentro de FOR (sem DECLARE)
*/
DECLARE
	CPFF funcionario.cpf%TYPE := '1111';
BEGIN
	FOR Registro_pesquisa IN (SELECT CPF, Nome FROM funcionario WHERE CPF=CPFF)
	LOOP
		DBMS_OUTPUT.PUT_LINE(Registro_pesquisa.CPF || ' ' ||Registro_pesquisa.Nome);
	END LOOP;
END;

/*
63. Procedimento sem parâmetro
*/
CREATE OR REPLACE PROCEDURE salarioMaiorIgual4500 AS
	CPFF Salario.CPF%TYPE;
	NomeF Salario.CPF%TYPE;
BEGIN
	SELECT salario.cpf,funcionario.nome INTO CPFF, NomeF
	FROM Salario, Funcionario
	WHERE ValorBruto >= 4500 AND salario.cpf = funcionario.cpf;
	DBMS_OUTPUT.PUT_LINE(Nomef || ' '|| CPFF);
END;

/*
64. Procedimento com parâmetro IN
*/
CREATE OR REPLACE PROCEDURE Escnome (CpfFunc IN Funcionario.CPF%TYPE) AS
	Nm Funcionario.nome%TYPE;
	CPFF funcionario.cpf%TYPE;
BEGIN
	SELECT CPF INTO CPFF
	From Funcionario
	WHERE CPF=CPFF;
	SELECT Nome INTO Nm
	FROM Funcionario
	WHERE CPF = CPFF;
	DBMS_OUTPUT.PUT_LINE(Nm);	
END;

/*	
65. Procedimento com parâmetro OUT
*/
CREATE OR REPLACE PROCEDURE MAIOR (SalCPF1 in Salario.CPF%TYPE, SalCPF2 IN Salario.CPF%TYPE, Z OUT Salario.ValorBruto%TYPE) IS
Vb Salario.ValorBruto%TYPE;
BEGIN
	IF SalCPF1 > SalCPF2 THEN
		Z:= SalCPF1;
	ELSE
		Z:= SalCPF2;
	END IF;
	SELECT ValorBruto INTO Vb
	FROM Salario
	WHERE ValorBruto = Z;
	DBMS_OUTPUT.PUT_LINE('Maior Salario: ' || Vb);
END;

/*
66. Procedimento com parâmetro INOUT
*/
CREATE OR REPLACE PROCEDURE SalarioAumento (S IN OUT salario.valorbruto%TYPE) IS
BEGIN
	IF S > 5000 THEN S := S;
	ElSIF S < 5000 THEN S := S*1.30;
	END IF;
END;

/*
67. Uso de procedimento dentro de outro bloco PL (pode-se usar um dos procedimentos
criados anteriormente)
*/
CREATE OR REPLACE PROCEDURE SelecionarCPFeUsarAumento (CPF_IN IN funcionario.cpf%TYPE) IS
salario_cpf salario.valorbruto%TYPE;
BEGIN
	SELECT salario.valorbruto INTO salario_cpf
	FROM salario
	WHERE salario.cpf = CPF_IN;
	Salarioaumento(salario_cpf);
	DBMS_OUTPUT.PUT_LINE(salario_cpf);
end;

/*
68. Função Sem parametro
*/
CREATE OR REPLACE FUNCTION num_func RETURN NUMBER IS
num_func NUMBER;
BEGIN
	SELECT count(*) INTO num_func FROM Funcionario ;
	RETURN num_func;
	END;

/*
69. Função com ​parâmetro IN
*/
CREATE OR REPLACE FUNCTION cod_depto(nome_in IN funcionario.nome%TYPE) RETURN NUMBER IS
 cod_dep NUMBER ;
BEGIN
	SELECT t.CodigoRelacionamento INTO cod_dep FROM funcionario f, trabalha t WHERE f.nome = nome_in AND f.cpf = t.cpf;
	RETURN cod_dep;
END;

/*
70. Função com parâmetro OUT
*/
CREATE OR REPLACE FUNCTION mudanca_Numero(Numero OUT funcionario.Numero%TYPE) RETURN Funcionario.nome%TYPE IS
	var_nome Funcionario.nome%TYPE;
BEGIN
	SELECT f.Nome INTO var_nome FROM funcionario f WHERE f.Numero = Numero;
	Numero := Numero + 1;
	RETURN var_nome;
END;

/*
71. Função com parâmetro INOUT
*/
CREATE OR REPLACE FUNCTION mudanca_Sal(cpf_in IN Funcionario.cpf%TYPE, Sal_Bruto IN OUT Salario.ValorBruto%TYPE) RETURN Funcionario.nome%TYPE IS
	var_nome Funcionario.nome%TYPE;
BEGIN
	SELECT f.Nome INTO var_nome FROM Funcionario f, Salario s WHERE s.cpf = f.cpf AND f.cpf = cpf_in;
	Sal_Bruto := Sal_Bruto * 1.01;
	RETURN var_nome;
END;

/*
72. Criação de pacote (declaração e corpo) com pelo menos dois componentes
*/
CREATE OR REPLACE PACKAGE q72 AS
FUNCTION num_func_f RETURN NUMBER;
END q72;
/
CREATE OR REPLACE PACKAGE BODY q72 AS
	tot_emps NUMBER;
	FUNCTION num_func_f RETURN NUMBER IS
		num_func_var NUMBER;
	BEGIN
		SELECT count(*) INTO num_func_var FROM Funcionario WHERE Sexo = 'F';
		RETURN num_func_var;
	END;
	PROCEDURE remove_emp (cpf_out Funcionario.cpf%TYPE) IS
	BEGIN
		DELETE FROM Funcionario
		WHERE Funcionario.cpf = remove_emp.cpf_out;
		tot_emps := tot_emps - 1;
	END;
END q72;

/*
73. BEFORE TRIGGER
*/
CREATE OR REPLACE TRIGGER atencao
BEFORE UPDATE ON Salario
FOR EACH ROW
DECLARE
	media NUMBER(12);
BEGIN
	SELECT AVG(ValorBruto) INTO media FROM Salario;
	IF :NEW.ValorBruto BETWEEN :OLD.ValorBruto AND media THEN
		:NEW.ValorBruto := :OLD.valorBruto + (:OLD.ValorBruto * 0.05);
		DBMS_OUTPUT.PUT_lINE('Aumento necessário, novo aumento de ' || :NEW.ValorBruto);
	ELSE
		DBMS_OUTPUT.PUT_LINE('Valor atualizado com sucesso');
	END IF;
END;

/*
74. AFTER TRIGGER
*/
CREATE OR REPLACE TRIGGER inf_alteracao_cpf
AFTER update on cliente
REFERENCING OLD AS O NEW AS N
FOR EACH ROW
BEGIN
	IF (:N.cpf<>:O.cpf) THEN
		DBMS_OUTPUT.PUT_LINE('CPF NOVO' || :N.cpf || 'CPF ANTIGO' || :O.cpf);
	END IF;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		BEGIN
			RAISE_APPLICATION_ERROR(-20001,'Nenhum CPF encontrado.');
		END;
END;

/*
75. TRIGGER de linha sem ​condição
*/
CREATE OR REPLACE TRIGGER atencao2
BEFORE delete or insert or update on cliente
FOR EACH ROW
BEGIN
	DBMS_OUTPUT.PUT_LINE('TEM CERTEZA?');
 END;
/
CREATE OR REPLACE TRIGGER lider_ja_cadastrado
BEFORE INSERT OR UPDATE ON leiturista
REFERENCING OLD AS O NEW AS N
FOR EACH ROW
BEGIN
	IF :O.lider = :N.lider THEN
		RAISE_APPLICATION_ERROR(-20004,'Leiturista já cadastrado');
	END IF;
END;

/*
76. TRIGGER de linha com ​condição
*/
CREATE OR REPLACE TRIGGER novo_cod_depart
AFTER UPDATE OF cpf ON chefe
REFERENCING OLD AS O NEW AS N
FOR EACH ROW
BEGIN
	IF :N.cpf IS NULL THEN
		DBMS_OUTPUT.PUT_LINE('Update impossível!');
	ELSE
		DBMS_OUTPUT.PUT_LINE('Update concluído.');
	END IF;
END;

/*
77. TRIGGER de comando
*/
CREATE OR REPLACE TRIGGER new_cpf
AFTER INSERT ON Funcionario
REFERENCING NEW AS N
FOR EACH ROW
BEGIN
	DBMS_OUTPUT.PUT_LINE('Valor do novo cpf adicionado:' || :N.cpf);
END;
/
CREATE OR REPLACE TRIGGER old_cpf
BEFORE delete on Funcionario
REFERENCING OLD AS O
FOR EACH ROW
BEGIN
	DBMS_OUTPUT.PUT_LINE('Deseja deletar o cpf:' || :O.cpf || '?');
END;

/*
78. Uso de NEW em TRIGGER de inserção
*/
CREATE OR REPLACE TRIGGER mostra_atualizacao
AFTER update on salario
REFERENCING OLD AS O NEW AS N
FOR EACH ROW
BEGIN
	DBMS_OUTPUT.PUT_LINE('Novo ValorBruto:' || :N.ValorBruto);
	DBMS_OUTPUT.PUT_LINE('Antigo ValorBruto:' || :O.ValorBruto);
END;

/*
79. Uso de OLD em TRIGGER de deleção
*/
CREATE OR REPLACE TRIGGER no_add_func
BEFORE INSERT ON Funcionario
REFERENCING NEW AS N OLD AS O
FOR EACH ROW
DECLARE
	numerofuncmax NUMBER;
	numerofuncN NUMBER;
BEGIN
	SELECT count(cpf) INTO numerofuncmax FROM Funcionario;
	SELECT count(:N.cpf) INTO numerofuncN FROM Funcionario;
	IF numerofuncmax = 16 AND (numerofuncmax < numerofuncN) THEN
		RAISE_APPLICATION_ERROR(-20004,' Número máx de func');
	END IF;
END;

/*
80.Uso de NEW e OLD em TRIGGER de atualização
*/
CREATE OR REPLACE TRIGGER aumento
BEFORE UPDATE ON salario
REFERENCING NEW AS N OLD AS O
FOR EACH ROW
DECLARE
	media NUMBER(12);
BEGIN
	SELECT AVG(ValorBruto) INTO media FROM salario;
	IF (:N.ValorBruto - :O.ValorBruto) > media THEN
		RAISE_APPLICATION_ERROR(-20004,' Não deve receber aumento');
	END IF;
END;

/*
81.Uso de TRIGGER para impedir inserção em tabela
*/
CREATE OR REPLACE TRIGGER obrigatoriedade_de_projeto
BEFORE INSERT on projeto
REFERENCING OLD AS O
FOR EACH ROW
BEGIN
	IF :O.cpf IS NOT NULL AND :O.numID IS NOT NULL THEN
		RAISE_APPLICATION_ERROR(-20004,'Delete inválido!');
	END IF;
END;

/*
82.Uso de TRIGGER para impedir atualização em tabela
*/
CREATE OR REPLACE TRIGGER obrigatoriedade_de_projeto1
BEFORE UPDATE on projeto
REFERENCING OLD AS O
FOR EACH ROW
BEGIN
	IF :O.cpf IS NOT NULL AND :O.numID IS NOT NULL THEN
		RAISE_APPLICATION_ERROR(-20004,'Delete inválido!');
	END IF;
END;

/*
83.Uso de TRIGGER para impedir deleção em tabela
*/
CREATE OR REPLACE TRIGGER obrigatoriedade_de_projeto2
BEFORE delete on projeto
REFERENCING OLD AS O
FOR EACH ROW
BEGIN
	IF :O.cpf IS NOT NULL AND :O.numID IS NOT NULL THEN
		RAISE_APPLICATION_ERROR(-20004,'Delete inválido!');
	END IF;
END;

/*
84.Uso de TRIGGER para inserir valores em outra tabela
*/
CREATE OR REPLACE TRIGGER mens_atualizacao
AFTER UPDATE of nome on Funcionario
REFERENCING OLD AS O NEW AS N
FOR EACH ROW
BEGIN
	IF UPDATING THEN -- codigodepartamento foi implementado como codigorelacionamento
		INSERT INTO LEITURISTA VALUES (	'54258943733', :N.nome);
		DBMS_OUTPUT.PUT_LINE('Nome do funcionario novo:' || :N.nome);
	END IF;
END;

/*
85. Uso de TRIGGER para atualizar valores em outra tabela
*/
CREATE OR REPLACE TRIGGER mens_atualizacao_up
AFTER UPDATE of nome on Funcionario
REFERENCING OLD AS O NEW AS N
FOR EACH ROW
BEGIN
	IF UPDATING THEN
		UPDATE LEITURISTA SET CPF = '54258943733' WHERE Lider = :N.nome;
		DBMS_OUTPUT.PUT_LINE('Nome do funcionario novo:' || :N.nome);
	END IF;
END;

/*
*
*
*
PL AVANÇADAS
*
*
*
*/

/*
86. Uso de TRIGGER para apagar valores em outra tabela
*/
CREATE OR REPLACE TRIGGER q86
BEFORE DELETE ON Funcionario
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
	DELETE FROM Telefone
	WHERE CPF = :OLD.CPF;
END q86;

/*
87. Uso de função dentro de uma consulta SQL (pode-se usar uma das funções criadas
anteriormente)
*/
SELECT Nome FROM Departamento WHERE CodigoRelacionamento = cod_depto('NOME');

/*
88. Registro como parâmetro de função ou procedimento
*/
CREATE OR REPLACE FUNCTION cod_depto(func_in IN funcionario%ROWTYPE) RETURN NUMBER IS
 cod_dep NUMBER ;
BEGIN
	SELECT t.CodigoRelacionamento INTO cod_dep FROM funcionario f, trabalha t WHERE f.nome = func_in.nome AND f.cpf = t.cpf;
	RETURN cod_dep;
END;

/*
89. Função com registro como retorno
*/
CREATE OR REPLACE FUNCTION cod_depto(func_in IN funcionario%ROWTYPE) RETURN trabalha%ROWTYPE IS
 trab trabalha%ROWTYPE;
BEGIN
	SELECT t.CPF, t.CodigoRelacionamento, t.DataTrabalha, t.CodOperacao INTO trab FROM funcionario f, trabalha t WHERE f.nome = func_in.nome AND f.cpf = t.cpf AND ROWNUM < 2;
	RETURN trab;
END;

/*
90. Pacote com funções ou procedimentos que usem outros componentes do mesmo
pacote
*/
CREATE OR REPLACE PACKAGE myNum AS
FUNCTION num_func_f RETURN NUMBER;
END myNum;
/
CREATE OR REPLACE PACKAGE BODY myNum AS
	tot_emps NUMBER;
	FUNCTION num_func_f RETURN NUMBER IS
		num_func_var NUMBER;
	BEGIN
		SELECT count(*) INTO num_func_var FROM Funcionario WHERE Sexo = 'F';
		RETURN num_func_var;
	END;
END myNum;

/*
91. INSTEAD OF TRIGGER
*/
CREATE OR REPLACE TRIGGER trg_upd_func_hom
INSTEAD OF INSERT ON view_Funcionario_Homens
DECLARE
	duplicate_info EXCEPTION;
	PRAGMA EXCEPTION_INIT (duplicate_info, -00001);
BEGIN
INSERT INTO Funcionario
	(CPF, Nome)
	VALUES (:NEW.CPF, :NEW.Nome);
EXCEPTION
	WHEN duplicate_info THEN
		RAISE_APPLICATION_ERROR (
		num=> -20111,
		msg=> 'PROIBIDO INSERIR DADO DUPLICADO');
END trg_cust_proj_view_insert;
