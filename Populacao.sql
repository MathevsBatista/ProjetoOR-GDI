-- INSERINDO HOSPITAL
INSERT INTO tb_hospital VALUES (tp_hospital('91707521000139', 'Hospital Santa Joana', tp_telefone('5581967645093'), tp_endereco('Pernambuco', 'Recife', 'Caxangá', 'Avenida Caxangá', '2000', '64506909', '')));
INSERT INTO tb_hospital VALUES (tp_hospital('67798588000141', 'Hospital Real Português', tp_telefone('5581997660093'), tp_endereco('Pernambuco', 'Recife', 'Boa Viagem', 'Avenida Boa Viagem', '3000', '55240389', '')));
INSERT INTO tb_hospital VALUES (tp_hospital('86652947000100', 'Hospital da Restauração', tp_telefone('5581954690093'), tp_endereco('Pernambuco', 'Recife', 'Caxangá', 'Avenida Caxangá', '2000', '64506909', '')));

-- INSERINDO BANCO
INSERT INTO tb_banco VALUES (tp_banco('70346672000139', tp_telefone('5581228143142'), tp_endereco('Pernambuco', 'Recife', 'Parnamirim', 'Rua das Jaguatiricas', '550', '55158072', ''), 'IMIP'));
INSERT INTO tb_banco VALUES (tp_banco('63180391000193', tp_telefone('5581967645093'), tp_endereco('Pernambuco', 'Recife', 'Boa Vista', 'Rua Dom Bosco', '723', '55157270', 'Bloco C'), 'HEMATO'));
INSERT INTO tb_banco VALUES (tp_banco('72989879000157', tp_telefone('5581954690093'), tp_endereco('Pernambuco', 'Recife', 'Graças', 'Rua Joaquim Nabuco', '171', '55152610', ''), 'HEMOPE'));

-- INSERINDO DOADOR
INSERT INTO tb_doador VALUES (tp_doador('13384332458', 'José Bezerra de Melo Neto', 'jbmn2@cin.ufpe.br', 72, TO_DATE('2000/05/16', 'yyyy/mm/dd'), 'M',
tp_telefone('5581997660099'), tp_endereco('Pernambuco', 'Recife', 'Boa Viagem', 'Avenida Boa Viagem', '100', '55150911', ''),
'A+', tp_nt_contato_de_apoio(tp_contato_de_apoio('5581991638394', 'Irlane da Silva Oliveira'))));

INSERT INTO tb_doador VALUES (tp_doador('13022560419', 'Maria Augusta Mota Borba', 'guta@cin.ufpe.br', 64, TO_DATE('1999/06/15', 'yyyy/mm/dd'), 'F',
tp_telefone('5581997666543'), tp_endereco('Pernambuco', 'Recife', 'Boa Viagem', 'Avenida Boa Viagem', '101', '55150911', ''),
'O+', tp_nt_contato_de_apoio(tp_contato_de_apoio('5581997660099', 'José Bezerra de Melo Neto'), tp_contato_de_apoio('5581997667699', 'Maria Augusta Amaral'))));

INSERT INTO tb_doador VALUES (tp_doador('11554314488', 'Victor Edmond Freire Gaudiot', 'gaudiot@cin.ufpe.br', 72, TO_DATE('1999/01/13', 'yyyy/mm/dd'), 'M',
tp_telefone('5581989666523'), tp_endereco('Pernambuco', 'Recife', 'Boa Viagem', 'Avenida Boa Viagem', '102', '55150911', ''),
'O+', tp_nt_contato_de_apoio(tp_contato_de_apoio('5581998765432', 'Gildo Vigor'))));

-- INSERINDO ENFERMEIRO
INSERT INTO tb_enfermeiro VALUES (tp_enfermeiro('11894086430', 'Matheus Isidoro Gomes Batista', 'isidoro@cin.ufpe.br', 66, TO_DATE('1999/04/10', 'yyyy/mm/dd'), 'M',
tp_telefone('5581949856523'), tp_endereco('Pernambuco', 'Recife', 'Boa Viagem', 'Avenida Boa Viagem', '103', '55150911', ''),
'1234598-09', (SELECT REF(B) FROM Banco B WHERE CNPJ='70346672000139')));

INSERT INTO tb_enfermeiro VALUES (tp_enfermeiro('11019884444', 'Maria Clara Dionísio Amaral Gois', 'clara@cin.ufpe.br', 60, TO_DATE('2000/09/13', 'yyyy/mm/dd'), 'F',
tp_telefone('5581949856523'), tp_endereco('Pernambuco', 'Recife', 'Boa Viagem', 'Avenida Boa Viagem', '104', '55150911', ''),
'9875788-09', (SELECT REF(B) FROM tb_banco B WHERE CNPJ='70346672000139')));

-- INSERINDO CAMPANHA
INSERT INTO tb_campanha VALUES (tp_campanha(1, 'Campanha dos Legais'));
INSERT INTO tb_campanha VALUES (tp_campanha(2, 'Campanha dos Não Legais'));

-- INSERINDO ENFERMEIRO-DOADOR
INSERT INTO tb_enfermeiro_doador VALUES (tp_enfermeiro_doador('11019884444', '13384332458', TO_DATE('2020/03/23', 'yyyy/mm/dd'), '1', 'N'));
INSERT INTO tb_enfermeiro_doador VALUES (tp_enfermeiro_doador('11019884444', '11554314488', TO_DATE('2020/03/23', 'yyyy/mm/dd'), '2', 'N'));
INSERT INTO tb_enfermeiro_doador VALUES (tp_enfermeiro_doador('11894086430', '13022560419', TO_DATE('2020/03/23', 'yyyy/mm/dd'), '','N'));

-- INSERINDO SOLICITA
INSERT INTO tb_solicita VALUES (tp_solicita('70346672000139', '67798588000141', '11019884444', '13384332458', TO_DATE('2020/03/23', 'yyyy/mm/dd'), TO_DATE('2020/03/25', 'yyyy/mm/dd')));
INSERT INTO tb_solicita VALUES (tp_solicita('70346672000139', '86652947000100', '11019884444', '11554314488', TO_DATE('2020/03/23', 'yyyy/mm/dd'), TO_DATE('2020/03/26', 'yyyy/mm/dd')));