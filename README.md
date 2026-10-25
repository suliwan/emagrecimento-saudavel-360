# Emagrecimento Saudável 360°

Organizador de refeições e sugestões culinárias (não é prescrição nutricional). HTML + CSS + JS puro.

## Arquivos
- `index.html`: aplicação completa; as 100 receitas já estão embutidas, então abre direto (duplo clique) sem servidor.
- `receitas.json`: as mesmas 100 receitas extraídas do PDF (para consulta/edição). Se preferir carregá-lo via `fetch`, use um servidor local (`python -m http.server`), pois `file://` bloqueia `fetch`.
- `supabase_setup.sql`: tabelas, índices e políticas RLS.

## Executar
Abra `index.html` no navegador e clique em **Ver demonstração** (dados ficam só no navegador; não é autenticação real).

## Supabase
1. Crie um projeto em supabase.com e execute `supabase_setup.sql` no SQL Editor.
2. Em Project Settings > API, copie a **Project URL** e a chave **anon/public** para `SUPABASE_URL` e `SUPABASE_ANON_KEY` no início do `<script>` do `index.html`. Nunca use a `service_role` no front-end.
3. Em Authentication > URL Configuration, informe a URL do site. Configure o e-mail de confirmação/recuperação como preferir.
4. Criar conta não dá acesso: libere o comprador inserindo uma linha em `acessos` (`ativo = true`), conforme o comentário no final do SQL.

## O que já funciona / o que depende de configuração
- Sem configuração: modo demonstração, catálogo, planejador, lista de compras, favoritos, atividades.
- Com Supabase: cadastro, login, logout, recuperação de senha, checagem de acesso, preferências e favoritos por usuário. Planejamento, lista e atividades ficam no navegador nesta versão (a tabela `planejamentos`/`atividades` já existe para uma próxima etapa).
- Não implementado: webhook da Kiwify e exclusão da conta de login (exigem função de servidor com `service_role`).

## Kiwify (próxima etapa)
Crie uma Supabase Edge Function (ou outro serviço) que receba os eventos de compra aprovada, reembolso e cancelamento, valide a autenticidade conforme a documentação oficial da Kiwify e atualize `acessos.ativo` usando a `service_role` guardada como segredo no servidor. Consulte a documentação da Kiwify para o formato real dos eventos.

## Publicar
O arquivo é estático: Netlify, Vercel, Cloudflare Pages ou GitHub Pages (envie `index.html`).

## Limites
- Alérgenos, vegetariana e vegana são marcados por palavras-chave nos ingredientes e podem errar; a interface pede conferência de rótulos.
- O orçamento é coletado, mas o PDF não traz custos, então não influencia as sugestões.
- O PDF não tem fotos: os cartões usam espaço reservado.
- Sem auditoria de segurança ou jurídica (LGPD).
