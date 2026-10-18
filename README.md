# Loja BY — projeto inicial de e-commerce PHP/MySQL

Projeto inicial responsivo em PHP 8.1+ e MySQL/MariaDB. Inclui catálogo, busca, categorias, detalhe do produto, carrinho em sessão, checkout que registra pedidos, controle básico de estoque, consulta de pedido, painel administrativo e gerador de QR Code.

## 1. Requisitos
- PHP 8.1 ou superior com extensões `pdo_mysql` e `mbstring`.
- MySQL ou MariaDB.
- Apache/Nginx (XAMPP funciona para desenvolvimento local).

## 2. Instalar no XAMPP
1. Extraia a pasta `loja_by` dentro de `C:\xampp\htdocs\`.
2. Abra o phpMyAdmin ou DBeaver e execute todo o arquivo `schema.sql`.
3. Abra `config.php` e confira host, banco, usuário e senha. Por padrão: `localhost`, banco `loja_by`, usuário `root`, senha vazia (padrão comum do XAMPP; altere se seu ambiente for diferente).
4. Inicie Apache e MySQL no XAMPP.
5. Acesse `http://localhost/loja_by/`.
6. Para criar seu usuário administrador, abra `http://localhost/loja_by/criar_admin.php`, preencha nome, e-mail e uma senha forte com pelo menos 12 caracteres.
7. **Apague `criar_admin.php` imediatamente depois de criar o administrador.**
8. Acesse `http://localhost/loja_by/admin.php` e entre com os dados criados.

## 3. Estoque por tamanho e cor
O produto precisa ter ao menos uma variação cadastrada na tabela `variantes_estoque` para poder ser comprado. O painel cria a primeira variação quando cadastra o produto. Para adicionar outras variações, insira-as no banco de dados, por exemplo:

```sql
INSERT INTO variantes_estoque (produto_id, tamanho, cor, estoque)
VALUES (1, 'G', 'Preto', 8);
```

Consulte o ID real do produto antes de executar. Cada combinação tamanho/cor deve ser única por produto.

## 4. Link público e QR Code
- Localmente, `http://localhost/loja_by/` só funciona no seu computador.
- Para vender de verdade, contrate uma hospedagem compatível com PHP/MySQL, registre um domínio (opcional, mas recomendado), envie os arquivos e importe `schema.sql`.
- Ative HTTPS. Depois acesse `qrcode.php`, informe o link público real e gere/imprima o QR Code.
- Não divulgue um QR Code com endereço `localhost`.

## 5. Antes de aceitar pedidos reais — importante
Este é um **starter funcional para desenvolvimento**, não um sistema pronto para operação comercial sem revisão. O checkout atual registra o pedido e desconta o estoque, mas **não processa cobrança real**. Pix/cartão são apenas preferências registradas; não há confirmação automática de pagamento, cálculo de frete, emissão fiscal, envio de e-mail/WhatsApp, recuperação de senha ou área autenticada de cliente.

Antes de operar:
- Integrar um gateway de pagamento (ex.: Mercado Pago, PagBank ou Stripe, conforme disponibilidade e requisitos) usando checkout hospedado/tokenização; nunca guardar dados completos do cartão.
- Integrar cálculo/rastreamento de frete (Correios ou agregador), validar CEP e definir política de entrega/troca.
- Implementar webhooks assinados para confirmação de pagamento e idempotência de pedidos.
- Configurar SMTP para e-mails, logs, backups testados, HTTPS e monitoramento.
- Revisar segurança, CSRF, limites de tentativas de login, autorização, uploads de imagem, cabeçalhos, política de privacidade/LGPD e regras de cancelamento/devolução.
- O painel deste starter permite criar produtos e atualizar status de pedidos; para editar/apagar produtos e gerenciar cupons/clientes, ampliar o painel.
- Trocar imagens ilustrativas, dados de contato, preços, textos, políticas e informações da loja pelos dados reais.
- Criar usuário MySQL dedicado com privilégios mínimos; não usar `root` em produção.

## 6. Estrutura
- `index.php`: vitrine, categorias e busca
- `produto.php`: detalhe e seleção de variação
- `carrinho.php`: carrinho
- `checkout.php`: dados de entrega e registro do pedido
- `pedido.php`: consulta de pedido por código
- `admin.php`: login, painel, cadastro de produto e status de pedido
- `criar_admin.php`: cadastro inicial do administrador (apagar depois)
- `qrcode.php`: QR Code do endereço público
- `privacidade.php`: modelo inicial de privacidade
- `config.php`: conexão PDO e funções de segurança
- `schema.sql`: tabelas e dados ilustrativos
- `style.css`: estilo responsivo preto/dourado

## 7. Licença e dados de demonstração
Use como base e personalize. Confirme direitos/licenças de imagens antes de usar comercialmente.
