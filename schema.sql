CREATE DATABASE IF NOT EXISTS loja_by CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE loja_by;

CREATE TABLE IF NOT EXISTS admins (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  senha_hash VARCHAR(255) NOT NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categorias (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE,
  slug VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS produtos (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  categoria_id INT UNSIGNED NULL,
  nome VARCHAR(180) NOT NULL,
  slug VARCHAR(200) NOT NULL UNIQUE,
  descricao TEXT NULL,
  preco DECIMAL(10,2) NOT NULL DEFAULT 0,
  preco_promocional DECIMAL(10,2) NULL,
  imagem_url VARCHAR(500) NULL,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  destaque TINYINT(1) NOT NULL DEFAULT 0,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_produto_categoria FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS variantes_estoque (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  produto_id INT UNSIGNED NOT NULL,
  tamanho VARCHAR(20) NOT NULL DEFAULT 'Único',
  cor VARCHAR(50) NOT NULL DEFAULT 'Padrão',
  estoque INT NOT NULL DEFAULT 0,
  UNIQUE KEY uq_variante (produto_id, tamanho, cor),
  CONSTRAINT fk_variante_produto FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS clientes (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(140) NOT NULL,
  email VARCHAR(190) NOT NULL,
  telefone VARCHAR(30) NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_cliente_email (email)
);

CREATE TABLE IF NOT EXISTS pedidos (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(30) NOT NULL UNIQUE,
  cliente_id BIGINT UNSIGNED NULL,
  cliente_nome VARCHAR(140) NOT NULL,
  email VARCHAR(190) NOT NULL,
  telefone VARCHAR(30) NULL,
  cep VARCHAR(9) NOT NULL,
  endereco VARCHAR(220) NOT NULL,
  numero VARCHAR(20) NOT NULL,
  complemento VARCHAR(120) NULL,
  cidade VARCHAR(100) NOT NULL,
  estado CHAR(2) NOT NULL,
  forma_pagamento VARCHAR(30) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'Recebido',
  subtotal DECIMAL(10,2) NOT NULL,
  frete DECIMAL(10,2) NOT NULL DEFAULT 0,
  total DECIMAL(10,2) NOT NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS itens_pedido (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  pedido_id BIGINT UNSIGNED NOT NULL,
  produto_id INT UNSIGNED NULL,
  produto_nome VARCHAR(180) NOT NULL,
  tamanho VARCHAR(20) NOT NULL,
  cor VARCHAR(50) NOT NULL,
  quantidade INT UNSIGNED NOT NULL,
  preco_unitario DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_item_pedido FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
  CONSTRAINT fk_item_produto FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS cupons (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(40) NOT NULL UNIQUE,
  tipo ENUM('percentual','valor') NOT NULL DEFAULT 'percentual',
  valor DECIMAL(10,2) NOT NULL,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  validade DATE NULL
);

INSERT IGNORE INTO categorias (nome, slug) VALUES
('Masculino','masculino'),('Feminino','feminino'),('Calçados','calcados'),('Acessórios','acessorios');

INSERT IGNORE INTO produtos (categoria_id,nome,slug,descricao,preco,imagem_url,ativo,destaque)
SELECT id,'Camiseta BY Essential','camiseta-by-essential','Camiseta confortável para o dia a dia. Disponível em vários tamanhos.',79.90,'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=900&q=80',1,1 FROM categorias WHERE slug='masculino';
INSERT IGNORE INTO produtos (categoria_id,nome,slug,descricao,preco,imagem_url,ativo,destaque)
SELECT id,'Moletom Urban BY','moletom-urban-by','Moletom urbano, confortável e versátil.',159.90,'https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&w=900&q=80',1,1 FROM categorias WHERE slug='masculino';
INSERT IGNORE INTO produtos (categoria_id,nome,slug,descricao,preco,imagem_url,ativo,destaque)
SELECT id,'Calça Cargo Street','calca-cargo-street','Calça cargo com visual streetwear.',129.90,'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=900&q=80',1,0 FROM categorias WHERE slug='masculino';
