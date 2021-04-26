-- UTILIZANDO DEREF
SELECT DEREF(E.banco) FROM tb_enfermeiro E WHERE CPF='11894086430';

-- UTILIZANDO VALUE
SELECT VALUE(E) Values_Enfermeiros FROM tb_enfermeiro E;

-- UTILIZANDO CONSULTA A VARRAY
SELECT telefone FROM tb_doador WHERE CPF='11554314488';

-- UTILIZANDO CONSULTA A NESTED TABLE
SELECT contato_de_apoio FROM tb_doador WHERE CPF='11554314488';