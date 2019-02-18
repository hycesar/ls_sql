--
--Legenda
/*
tp tipo
tb tabela
va varray
nt nested table
rf referencia
en endereço
fu Funcionario
ch chefe
le leiturista
cl cliente
pr projeto
se serviço
eq equipamento
re realiza
de departamento
tr trabalha
sa salario
*/
--
--Apagar todas as tabelas existentes
DROP TABLE tb_salario;
DROP TABLE tb_trabalha;
DROP TABLE tb_departamento;
DROP TABLE tb_realiza;
DROP TABLE tb_equipamento;
DROP TABLE tb_servico;
DROP TABLE tb_projeto;
DROP TABLE tb_cliente;
DROP TABLE tb_leiturista;
DROP TABLE tb_chefe;
--DROP TABLE tb_funcionario;
--
--Apagar todos os tipo
DROP TYPE tp_salario FORCE;
DROP TYPE tp_trabalha FORCE;
DROP TYPE tp_departamento FORCE;
DROP TYPE tp_realiza FORCE;
DROP TYPE tp_servico FORCE;
DROP TYPE tp_equipamento FORCE;
DROP TYPE tp_projeto FORCE;
DROP TYPE tp_cliente FORCE;
DROP TYPE tp_leiturista FORCE;
DROP TYPE tp_chefe FORCE;
DROP TYPE tp_funcionario FORCE;
DROP TYPE tp_va_endereco FORCE;
DROP TYPE tp_endereco FORCE;
DROP TYPE tp_nt_fone FORCE;
--
--Criar os tipos
--Q4. Criação de um tipo que contenha um atributo que seja de um tipo NESTED TABLE
CREATE OR REPLACE TYPE tp_nt_fone AS TABLE OF NUMBER(13);
/
--Q2. Criação de um tipo que contenha um atributo que seja de um outro tipo
CREATE OR REPLACE TYPE tp_endereco AS OBJECT(
	en_Rua VARCHAR2(50),
	en_Bairro VARCHAR2(50),
	en_Casa VARCHAR2(2)
) FINAL;
/
--Q11. Alteração de tipo: adição de atributo
ALTER TYPE tp_endereco
	ADD ATTRIBUTE en_Numero VARCHAR2(5);

--Q12. Alteração de tipo: modificação de atributo
ALTER TYPE tp_endereco
	MODIFY ATTRIBUTE en_Numero VARCHAR2(10);

--Q13. Alteração de tipo: remoção de atributo
ALTER TYPE tp_endereco
	DROP ATTRIBUTE en_Casa; 

--Q3. Criação de um tipo que contenha um atributo que seja de um tipo VARRAY
CREATE OR REPLACE TYPE tp_va_endereco AS VARRAY(1) OF tp_endereco;
/
--Q9. Criação e chamada de método abstrato
CREATE OR REPLACE TYPE tp_funcionario AS OBJECT(
	fu_CPF VARCHAR2(11),
	fu_Nome VARCHAR2(50),
	fu_Sexo VARCHAR2(10),
	fu_DataNasc DATE,
	fu_Email VARCHAR2(50),
	fu_Fone tp_nt_fone,
	fu_Endereço tp_va_endereco,
	MEMBER PROCEDURE imprime
) NOT INSTANTIABLE NOT FINAL;
/
--Q5. Criação e chamada de um método construtor (diferente do padrão)
ALTER TYPE tp_endereco
	ADD CONSTRUCTOR FUNCTION tp_endereco(
		var_rua VARCHAR2,
		var_bairro VARCHAR2
	) RETURN SELF AS RESULT CASCADE;

CREATE OR REPLACE TYPE BODY tp_endereco AS
	CONSTRUCTOR FUNCTION tp_endereco(
		var_rua VARCHAR2,
		var_bairro VARCHAR2
	) RETURN SELF AS RESULT AS
	BEGIN
		SELF.en_Rua := var_rua;
		SELF.en_Bairro := var_bairro;
		SELF.en_Numero := 's/n';
		RETURN;
	END;
END;
/
--Q1. Criação de tipo e subtipo
CREATE OR REPLACE TYPE tp_chefe UNDER tp_funcionario(
) FINAL;
/
--Q14. Alteração de supertipo com propagação de mudança
ALTER TYPE tp_funcionario
	ADD ATTRIBUTE status VARCHAR2(50) CASCADE;

--Q15. Alteração de supertipo com invalidação de subtipos afetados
ALTER TYPE tp_funcionario
	DROP ATTRIBUTE status INVALIDATE;

CREATE OR REPLACE TYPE tp_leiturista UNDER tp_funcionario(
	le_rf_lider REF tp_leiturista
) FINAL;
/
CREATE OR REPLACE TYPE tp_cliente AS OBJECT(
	cl_CodCliente VARCHAR2(10),
	cl_PrecoCompra NUMBER(10,2),
	cl_DataNegociacao DATE,
	cl_rf_vendedor REF tp_chefe
) FINAL;
/
CREATE OR REPLACE TYPE tp_projeto AS OBJECT(
	pr_NumID VARCHAR2(10),
	pr_CodSetor VARCHAR2(10),
	pr_DataInicio DATE,
	pr_Tema VARCHAR2(75),
	pr_desenvolvedor VARCHAR2(11),
	pr_rf_desenvolvedor REF tp_chefe
) FINAL;
/
CREATE OR REPLACE TYPE tp_servico AS OBJECT(
	se_CodServico VARCHAR2(10),
	se_Nome VARCHAR2(50),
	se_rf_lider REF tp_leiturista
) FINAL;
/
CREATE OR REPLACE TYPE tp_equipamento AS OBJECT(
	eq_Codigo VARCHAR2(10),
	eq_Estado VARCHAR2(5),
	eq_DataCompra DATE
) FINAL;
/
CREATE OR REPLACE TYPE tp_realiza AS OBJECT(
	re_Codigo VARCHAR2(10),
	re_DataRealiza DATE,
	re_leiturista VARCHAR2(11),
	re_serviço VARCHAR2(10),
	re_equipamento VARCHAR2(10),
	re_rf_leiturista REF tp_leiturista,
	re_rf_serviço REF tp_servico,
	re_rf_equipamento REF tp_equipamento
) FINAL;
/
CREATE OR REPLACE TYPE tp_departamento AS OBJECT(
	de_Codigo VARCHAR2(10),
	de_Nome VARCHAR2(50),
	de_NumProjeto VARCHAR2(10)
) FINAL;
/
CREATE OR REPLACE TYPE tp_trabalha AS OBJECT(
	tr_CodOperacao VARCHAR2(10),
	tr_DataTrabalha DATE,
	tr_funcionario VARCHAR2(11),
	tr_departamento VARCHAR2(10),
	tr_rf_funcionario REF tp_funcionario,
	tr_rf_departamento REF tp_departamento
) FINAL;
/
CREATE OR REPLACE TYPE tp_salario AS OBJECT(
	sa_Id VARCHAR2(11),
	sa_DataTrabalha DATE,
	sa_ValorBruto NUMBER(10,2),
	sa_ValorImposto NUMBER(10,2),
	sa_rf_funcionario REF tp_funcionario,
	sa_rf_trabalha REF tp_trabalha,
	sa_rf_departamento REF tp_departamento
) FINAL;
/


--Q18. Criação de todas as tabela a partir de um tipo
--Criar tabelas
--NOT SUBSTITUTABLE AT ALL LEVELS
/*CREATE TABLE tb_funcionario OF tp_funcionario(
	fu_CPF PRIMARY KEY
) NESTED TABLE fu_Fone STORE AS tb_fone;*/
CREATE TABLE tb_chefe OF tp_chefe(
	fu_CPF PRIMARY KEY,
	fu_Nome NOT NULL,
	fu_Sexo NOT NULL,
	fu_DataNasc NOT NULL,
	fu_Endereço NOT NULL,
	CONSTRAINT CHEFE_CHECK CHECK (fu_Sexo = 'M' OR fu_Sexo = 'F' OR fu_Sexo = 'Masculino' OR fu_Sexo = 'Feminino')
) NESTED TABLE fu_Fone STORE AS tb_fone_chefe;
--Q16. Uso de referência e controle de integridade referencial
CREATE TABLE tb_leiturista OF tp_leiturista(
	fu_CPF PRIMARY KEY,
	fu_Nome NOT NULL,
	fu_Sexo NOT NULL,
	fu_DataNasc NOT NULL,
	fu_Endereço NOT NULL,
	--le_rf_lider WITH ROWID REFERENCES tb_leiturista,
	FOREIGN KEY (le_rf_lider) REFERENCES tb_leiturista,
	CONSTRAINT LEITURISTA_CHECK CHECK (fu_Sexo = 'M' OR fu_Sexo = 'F' OR fu_Sexo = 'Masculino' OR fu_Sexo = 'Feminino')
) NESTED TABLE fu_Fone STORE AS tb_fone_leiturista;
--Q17. Restrição de escopo de referência
CREATE TABLE tb_cliente OF tp_cliente(
	cl_CodCliente PRIMARY KEY,
	cl_PrecoCompra NOT NULL,
	cl_DataNegociacao NOT NULL,
	FOREIGN KEY (cl_rf_vendedor) REFERENCES tb_chefe
);
CREATE TABLE tb_projeto OF tp_projeto(
	PRIMARY KEY(pr_desenvolvedor, pr_NumID),
	FOREIGN KEY(pr_rf_desenvolvedor) REFERENCES tb_chefe
);
CREATE TABLE tb_servico OF tp_servico(
	se_CodServico PRIMARY KEY,
	FOREIGN KEY(se_rf_lider) REFERENCES tb_leiturista
);
CREATE TABLE tb_equipamento OF tp_equipamento(
	eq_Codigo PRIMARY KEY,
	eq_Estado NOT NULL,
	CONSTRAINT Equipamento_Check CHECK (eq_Estado = 'RUIM' or eq_Estado = 'BOM')
);
CREATE TABLE tb_realiza OF tp_realiza(
	PRIMARY KEY(re_leiturista, re_equipamento, re_serviço),
	re_DataRealiza  DEFAULT SYSDATE NOT NULL,
	FOREIGN KEY(re_rf_leiturista) REFERENCES tb_leiturista,
	FOREIGN KEY(re_rf_serviço) REFERENCES tb_servico,
	FOREIGN KEY(re_rf_equipamento) REFERENCES tb_equipamento
);
CREATE TABLE tb_departamento OF tp_departamento(
	PRIMARY KEY(de_Codigo)
);
CREATE TABLE tb_trabalha OF tp_trabalha(
	PRIMARY KEY(tr_funcionario, tr_departamento, tr_DataTrabalha, tr_CodOperacao),
	--FOREIGN KEY(tr_rf_funcionario) REFERENCES tb_funcionario,
	FOREIGN KEY(tr_rf_departamento) REFERENCES tb_departamento
);
CREATE TABLE tb_salario OF tp_salario(
	sa_DataTrabalha NOT NULL,
	FOREIGN KEY (sa_rf_departamento) REFERENCES tb_departamento,
	--FOREIGN KEY (sa_rf_funcionario) REFERENCES tb_funcionario,
	FOREIGN KEY (sa_rf_trabalha) REFERENCES tb_trabalha
);
--
--Povoar
INSERT INTO tb_chefe VALUES (
	tp_chefe(
		'91331589776',
		'Seu Barriga',
		'M',
		TO_DATE('07/02/1972', 'dd/mm/yyyy'),
		'barrigaEpesado@hotmail.com',
		tp_nt_fone(91234567),
		tp_va_endereco(
			tp_endereco(
				'Rua Imperial',
				'Centro',
				'1'
			)
		)
	)
);
INSERT INTO tb_chefe VALUES (
	tp_chefe(
		'13959221626',
		'Maria Naruse',
		'F',
		TO_DATE('15/02/1994', 'dd/mm/yyyy'),
		'maria@gmail.com',
		tp_nt_fone(91234567),
		tp_va_endereco(
			tp_endereco(
				'Av Polidoro',
				'Varzea',
				'2'
			)
		)
	)
);
--Q5. Criação e chamada de um método construtor (diferente do padrão)
INSERT INTO tb_chefe VALUES (
	tp_chefe(
		'64175008566',
		'Roronoa Zoro',
		'M',
		TO_DATE('04/02/1994', 'dd/mm/yyyy'),
		'Zoro@gmail.com',
		tp_nt_fone(91234567),
		tp_va_endereco(
			tp_endereco(
				'Av dos Professores',
				'Cidade Universitaria'
			)
		)
	)
);
INSERT INTO tb_leiturista VALUES (
	tp_leiturista(
		'32370064143',
		'Dona Clotilde',
		'F',
		TO_DATE('01/02/1971', 'dd/mm/yyyy'),
		'bruxa@hotmail.com',
		tp_nt_fone(2345678),
		tp_va_endereco(
			tp_endereco(
				'Sem Rua',
				'Vila',
				'71'
			)
		),
		NULL
	)
);
INSERT INTO tb_leiturista VALUES (
	tp_leiturista(
		'32370064143',
		'Dona Clotilde',
		'F',
		TO_DATE('01/02/1971', 'dd/mm/yyyy'),
		'bruxa@hotmail.com',
		tp_nt_fone(2345678),
		tp_va_endereco(
			tp_endereco(
				'Sem Rua',
				'Vila',
				'71'
			)
		),
		NULL
	)
);
INSERT INTO tb_leiturista VALUES (
	tp_leiturista(
		'32370064143',
		'Dona Clotilde',
		'F',
		TO_DATE('01/02/1971', 'dd/mm/yyyy'),
		'bruxa@hotmail.com',
		tp_nt_fone(2345678),
		tp_va_endereco(
			tp_endereco(
				'Sem Rua',
				'Vila',
				'71'
			)
		),
		NULL
	)
);
INSERT INTO tb_cliente VALUES (
	tp_cliente(
		'1',
		'100,00',
		'10/10/2001',
		'91331589776'
	)
);
INSERT INTO tb_cliente VALUES (
	tp_cliente(
		'2',
		'10,00',
		'10/10/2011',
		'91331589776'
	)
);

/*
--
--Apagar todas as tabelas existentes
DROP TABLE tb_salario;
DROP TABLE tb_trabalha;
DROP TABLE tb_departamento;
DROP TABLE tb_realiza;
DROP TABLE tb_equipamento;
DROP TABLE tb_servico;
DROP TABLE tb_projeto;
DROP TABLE tb_cliente;
DROP TABLE tb_leiturista;
DROP TABLE tb_chefe;
--DROP TABLE tb_funcionario;
--
--Apagar todos os tipo
DROP TYPE tp_salario FORCE;
DROP TYPE tp_trabalha FORCE;
DROP TYPE tp_departamento FORCE;
DROP TYPE tp_realiza FORCE;
DROP TYPE tp_servico FORCE;
DROP TYPE tp_equipamento FORCE;
DROP TYPE tp_projeto FORCE;
DROP TYPE tp_cliente FORCE;
DROP TYPE tp_leiturista FORCE;
DROP TYPE tp_chefe FORCE;
DROP TYPE tp_funcionario FORCE;
DROP TYPE tp_va_endereco FORCE;
DROP TYPE tp_endereco FORCE;
DROP TYPE tp_nt_fone FORCE;

*/