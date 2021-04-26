DROP TYPE tp_telefone FORCE;
DROP TYPE tp_endereco FORCE;
DROP TYPE tp_banco FORCE;
DROP TYPE tp_hospital FORCE;
DROP TYPE tp_pessoa FORCE;
DROP TYPE tp_enfermeiro FORCE;
DROP TYPE tp_contato_de_apoio FORCE;
DROP TYPE tp_doador FORCE;
DROP TYPE tp_campanha FORCE;
DROP TYPE tp_enfermeiro_doador FORCE;
DROP TYPE tp_solicita FORCE;

CREATE OR REPLACE TYPE tp_telefone AS VARRAY(5) OF VARCHAR2(14);
/
CREATE OR REPLACE TYPE tp_endereco AS OBJECT (
    estado VARCHAR2(30),
    cidade VARCHAR2(30),
    bairro VARCHAR2(30),
    rua VARCHAR2(30),
    numero VARCHAR2(6),
    cep VARCHAR2(9),
    complemento VARCHAR2(30)
) FINAL;
/
CREATE OR REPLACE TYPE tp_banco AS OBJECT (
    cnpj VARCHAR2(14),
    telefone tp_telefone,
    endereco tp_endereco,
    MEMBER PROCEDURE exibirDetalhes(SELF tp_banco)
) FINAL;
/
CREATE OR REPLACE TYPE BODY tp_banco AS
 MEMBER PROCEDURE exibirDetalhes ( SELF tp_projeto) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Detalhes do Banco');
        DBMS_OUTPUT.PUT_LINE('CNPJ: ' || cnpj);
        DBMS_OUTPUT.PUT_LINE(' Nome: ' || nome);
        DBMS_OUTPUT.PUT_LINE(' Telefone(s):');
        FOR table_i iN 1..5 LOOP
            DBMS_OUTPUT.PUT_LINE(' 0' || table_i || ' : ' || telefone(table_i));
        END LOOP;

        DBMS_OUTPUT.PUT_LINE(' RUA: ' || endereco.rua);
        DBMS_OUTPUT.PUT_LINE(' NUMERO: ' || endereco.numero);
        DBMS_OUTPUT.PUT_LINE(' CEP: ' || endereco.cep);
    END;
END;
/
ALTER TYPE tp_banco ADD ATTRIBUTE (nome VARCHAR2(100)) CASCADE;
/
CREATE OR REPLACE TYPE tp_hospital AS OBJECT (
    cnpj VARCHAR2(14),
    nome VARCHAR2(100),
    telefone tp_telefone,
    endereco tp_endereco
) FINAL;
/
CREATE OR REPLACE TYPE tp_pessoa AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(100),
    email VARCHAR2(30),
    peso NUMBER(3),
    data_nasc DATE,
    sexo CHAR,
    telefone tp_telefone,
    endereco tp_endereco,
    ORDER MEMBER FUNCTION comparaPeso(pessoa tp_pessoa) RETURN INTEGER,
    MEMBER FUNCTION calcularIMC(altura NUMBER) RETURN NUMBER
) NOT FINAL NOT INSTANTIABLE;
/
CREATE OR REPLACE TYPE BODY tp_pessoa AS
    ORDER MEMBER FUNCTION comparaPeso(pessoa tp_pessoa) RETURN INTEGER IS
    BEGIN
        RETURN SELF.peso - pessoa.peso;
    END;

    MEMBER FUNCTION calcularIMC(altura NUMBER) RETURN INTEGER IS
    BEGIN
        RETURN SELF.peso / (altura*altura);
    END;
END;
/
CREATE OR REPLACE TYPE tp_enfermeiro UNDER tp_pessoa(
    conta_bancaria VARCHAR2(10),
    banco REF tp_banco,
    cpf_lider VARCHAR2(11),
    CONSTRUCTOR FUNCTION tp_enfermeiro(pessoa_cpf VARCHAR2, pessoa_nome VARCHAR2, pessoa_email VARCHAR2, pessoa_peso NUMBER, pessoa_data_nasc DATE, pessoa_sexo CHAR, pessoa_telefone tp_telefone, pessoa_endereco tp_endereco, conta_bancaria_param VARCHAR2, banco_param REF tp_banco) RETURN SELF AS RESULT
);
/
CREATE OR REPLACE TYPE BODY tp_enfermeiro AS
    CONSTRUCTOR FUNCTION tp_enfermeiro(pessoa_cpf VARCHAR2, pessoa_nome VARCHAR2, pessoa_email VARCHAR2, pessoa_peso NUMBER, pessoa_data_nasc DATE, pessoa_sexo CHAR, pessoa_telefone tp_telefone, pessoa_endereco tp_endereco, conta_bancaria_param VARCHAR2, banco_param REF tp_banco) RETURN SELF AS RESULT IS
    BEGIN
        cpf := pessoa_cpf;
        nome := pessoa_nome;
        email := pessoa_email;
        peso := pessoa_peso;
        data_nasc := pessoa_data_nasc;
        sexo := pessoa_sexo;
        telefone := pessoa_telefone;
        endereco := pessoa_endereco;
        conta_bancaria := conta_bancaria_param;
        banco := banco_param;
        RETURN;
    END;
END;
/
CREATE OR REPLACE TYPE tp_contato_de_apoio AS OBJECT(
    telefone VARCHAR2(13),
    nome VARCHAR2(100)
) FINAL;
/
CREATE OR REPLACE TYPE tp_nt_contato_de_apoio AS TABLE OF tp_contato_de_apoio;
/
CREATE OR REPLACE TYPE tp_doador UNDER tp_pessoa(
    tipo_sang VARCHAR2(3),
    contato_de_apoio tp_nt_contato_de_apoio,
    CONSTRUCTOR FUNCTION tp_doador(pessoa_cpf VARCHAR2, pessoa_nome VARCHAR2, pessoa_email VARCHAR2, pessoa_peso NUMBER, pessoa_data_nasc DATE, pessoa_sexo CHAR, pessoa_telefone tp_telefone, pessoa_endereco tp_endereco, tipo_sang_param VARCHAR2, contato_de_apoio_param tp_contato_de_apoio) RETURN SELF AS RESULT,
    OVERRIDING MEMBER FUNCTION calcularIMC(altura NUMBER) RETURN NUMBER
);
/
CREATE OR REPLACE TYPE BODY tp_doador AS
    CONSTRUCTOR FUNCTION tp_doador(pessoa_cpf VARCHAR2, pessoa_nome VARCHAR2, pessoa_email VARCHAR2, pessoa_peso NUMBER, pessoa_data_nasc DATE, pessoa_sexo CHAR, pessoa_telefone tp_telefone, pessoa_endereco tp_endereco, tipo_sang_param VARCHAR2, contato_de_apoio_param tp_contato_de_apoio) RETURN SELF AS RESULT IS
    BEGIN
        cpf := pessoa_cpf;
        nome := pessoa_nome;
        email := pessoa_email;
        peso := pessoa_peso;
        data_nasc := pessoa_data_nasc;
        sexo := pessoa_sexo;
        telefone := pessoa_telefone;
        endereco := pessoa_endereco;
        tipo_sang := tipo_sang_param;
        contato_de_apoio := contato_de_apoio_param;
        RETURN;
    END;

    OVERRIDING MEMBER FUNCTION calcularIMC(altura NUMBER) RETURN NUMBER IS
    valorIMC NUMBER;
    necessitaTeste NUMBER := 1;
    BEGIN
        valorIMC := SELF.peso / (altura*altura);
        IF (valorIMC >= 18.5 AND valorIMC < 25) THEN
            necessitaTeste := 0;
        END IF;
        RETURN necessitaTeste;
    END;
END;
/
CREATE OR REPLACE TYPE tp_campanha AS OBJECT (
    id NUMBER(5),
    nome VARCHAR2(100)
);
/
CREATE OR REPLACE TYPE tp_enfermeiro_doador AS OBJECT (
    cpf_e VARCHAR2(11),
    cpf_d VARCHAR2(11),
    data_coleta DATE,
    campanha_id VARCHAR2(11),
    solicitado CHAR,
    MEMBER FUNCTION sanguesCompativeis(tipo_sang VARCHAR2) RETURN VARCHAR2
);
/
CREATE OR REPLACE TYPE BODY tp_enfermeiro_doador AS
    MEMBER FUNCTION sanguesCompativeis RETURN VARCHAR2(30) IS
    sanguesCompativeis VARCHAR2(30)
    BEGIN
        CASE v_tipo_sang_receptor
            WHEN 'AB+' THEN
                sanguesCompativeis = 'A+, A-, B+, B-, O+, O-, AB+, AB-';
            WHEN 'AB-' THEN
                sanguesCompativeis = 'A-, B-, O-, AB-';
            WHEN 'A+' THEN
                sanguesCompativeis = 'A-, A+, O-, O+';
            WHEN 'A-' THEN
                sanguesCompativeis = 'A-, O-';
            WHEN 'B+' THEN
                sanguesCompativeis = 'B-, B+, O-, O+';
            WHEN 'B-' THEN
                sanguesCompativeis = 'O-, B-';
            WHEN 'O+' THEN
                sanguesCompativeis = 'O-, O+';
            WHEN 'O-' THEN
                sanguesCompativeis = 'O-';
        END CASE;

        RETURN sanguesCompativeis;
    END;
END;
/
CREATE OR REPLACE TYPE tp_solicita AS OBJECT (
    cnpj_b VARCHAR2(14),
    cnpj_h VARCHAR2(14),
    cpf_e VARCHAR2(11),
    cpf_d VARCHAR2(11),
    data_coleta DATE,
    data_solicitacao DATE,
    MAP MEMBER FUNCTION getDataSolicitacao RETURN DATE
);
/
CREATE OR REPLACE TYPE BODY tp_solicita AS
    MAP MEMBER FUNCTION getDataSolicitacao RETURN DATE IS
    BEGIN
        RETURN data_solicitacao;
    END;
END;
/
CREATE TABLE tb_banco OF tp_banco (CNPJ PRIMARY KEY);
/
CREATE TABLE tb_hospital OF tp_hospital (CNPJ PRIMARY KEY);
/
CREATE TABLE tb_enfermeiro OF tp_enfermeiro (CPF PRIMARY KEY, banco WITH ROWID REFERENCES tb_banco);
/
CREATE TABLE tb_contato_de_apoio OF tp_contato_de_apoio;
/
CREATE TABLE tb_doador OF tp_doador (CPF PRIMARY KEY) NESTED TABLE contato_de_apoio STORE AS tb_contatos_de_apoio;
/
CREATE TABLE tb_campanha OF tp_campanha (ID PRIMARY KEY);
/
CREATE TABLE tb_enfermeiro_doador OF tp_enfermeiro_doador (PRIMARY KEY (CPF_E, CPF_D, DATA_COLETA));
/
CREATE TABLE tb_solicita OF tp_solicita (PRIMARY KEY (CNPJ_B, CNPJ_H, CPF_E, CPF_D, DATA_COLETA));
/
