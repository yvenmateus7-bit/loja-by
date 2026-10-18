<?php
require __DIR__.'/config.php';
$q = trim($_GET['q'] ?? '');
$cat = trim($_GET['categoria'] ?? '');
$sql = "SELECT p.*, c.nome AS categoria FROM produtos p LEFT JOIN categorias c ON c.id=p.categoria_id WHERE p.ativo=1";
$args=[];
if($q!==''){ $sql.=" AND (p.nome LIKE ? OR p.descricao LIKE ?)"; $args[]="%$q%"; $args[]="%$q%"; }
if($cat!==''){ $sql.=" AND c.slug=?"; $args[]=$cat; }
$sql.=" ORDER BY p.destaque DESC,p.criado_em DESC";
$st=db()->prepare($sql);$st->execute($args);$products=$st->fetchAll();
$cats=db()->query("SELECT * FROM categorias ORDER BY nome")->fetchAll();
function product_price($p){return $p['preco_promocional']!==null?(float)$p['preco_promocional']:(float)$p['preco'];}
?>
<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Loja BY | Sua marca, seu estilo</title><meta name="description" content="Moda, atitude e estilo na Loja BY. Encontre sua próxima peça favorita."><link rel="stylesheet" href="style.css"></head><body>
<header class="top"><a class="brand" href="index.php"><span class="logo">BY</span><span>LOJA BY<small>SUA MARCA, SEU ESTILO</small></span></a><nav class="nav"><a href="index.php">Início</a><a href="#produtos">Produtos</a><a href="carrinho.php">Carrinho (<?=cart_count()?>)</a><a href="pedido.php">Meus pedidos</a></nav></header>
<main class="wrap"><section class="hero"><div><span class="gold">NOVA COLEÇÃO • BY</span><h1>Vista seu estilo.<br><span class="gold">Marque presença.</span></h1><p>Peças escolhidas para acompanhar você em todos os momentos. Descubra seu próximo visual na Loja BY.</p><a class="btn" href="#produtos">COMPRAR AGORA ↗</a></div></section>
<div class="section-head"><div><h2>Encontre seu estilo</h2><p class="muted">Explore nossas categorias</p></div></div>
<div class="nav" style="margin-bottom:25px"><?php foreach($cats as $c):?><a class="btn outline" href="?categoria=<?=h($c['slug'])?>"><?=h($c['nome'])?></a><?php endforeach?><a class="btn outline" href="index.php">Todos</a></div>
<section id="produtos"><div class="section-head"><div><h2><?= $q ? 'Resultados da busca' : 'Destaques da BY' ?></h2><p class="muted"><?=count($products)?> produto(s) encontrados</p></div><form method="get" style="display:flex;gap:8px;max-width:360px;width:100%"><input class="search" name="q" placeholder="Buscar roupa..." value="<?=h($q)?>"><button class="btn">Buscar</button></form></div>
<div class="grid"><?php foreach($products as $p):?><article class="product"><a href="produto.php?id=<?=$p['id']?>"><img loading="lazy" src="<?=h($p['imagem_url'] ?: 'https://placehold.co/600x700?text=Loja+BY')?>" alt="<?=h($p['nome'])?>"></a><div class="product-info"><?php if($p['destaque']):?><span class="tag">DESTAQUE BY</span><?php endif?><h3><a href="produto.php?id=<?=$p['id']?>"><?=h($p['nome'])?></a></h3><div class="price"><?=money(product_price($p))?></div><p class="muted" style="font-size:12px"><?=h($p['categoria']??'Moda')?></p><a class="btn" style="width:100%" href="produto.php?id=<?=$p['id']?>">Ver produto</a></div></article><?php endforeach?></div>
<?php if(!$products):?><div class="empty">Não encontramos produtos com essa busca.</div><?php endif?></section>
<section class="card" style="background:#111;color:#fff"><h2 class="gold">Seu estilo, do seu jeito.</h2><p>Compra fácil, atendimento próximo e novidades sempre chegando.</p><a class="btn" href="https://wa.me/" target="_blank" rel="noopener">Falar no WhatsApp</a></section></main>
<footer class="footer"><div class="footer-inner"><div class="brand"><span class="logo">BY</span><span>LOJA BY<small>SUA MARCA, SEU ESTILO</small></span></div><div>Atendimento: configure seu WhatsApp e e-mail<br><small>© <?=date('Y')?> Loja BY. Todos os direitos reservados.</small></div><div><a href="privacidade.php">Privacidade</a> · <a href="admin.php">Administração</a></div></div></footer></body></html>
