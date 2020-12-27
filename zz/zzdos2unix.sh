# ----------------------------------------------------------------------------
# Converte arquivos texto no formato Windows/DOS (CR+LF) para o Unix (LF).
# Obs.: Também remove a permissão de execução do arquivo, caso presente.
# Uso: zzdos2unix arquivo(s)
# Ex.: zzdos2unix frases.txt
#      cat arquivo.txt | zzdos2unix
#
# Autor: Aurelio Marinho Jargas, www.aurelio.net
# Desde: 2000-02-22
# Versão: 2
# Licença: GPL
# Tags: arquivo, conversão
# ----------------------------------------------------------------------------
zzdos2unix()
{
	zzzz -h dos2unix "$1" && return

	local arquivo tmp
	local control_m=$(printf '\r') # ^M, CR, \r

	# Sem argumentos, lê/grava em STDIN/STDOUT
	if test $# -eq 0; then
		sed "s/$control_m*$//"

		# Facinho, terminou já
		return
	fi

	# Definindo arquivo temporário quando há argumentos.
	tmp=$(zztool mktemp dos2unix)

	# Usuário passou uma lista de arquivos
	# Os arquivos serão sobrescritos, todo cuidado é pouco
	for arquivo; do
		# O arquivo existe?
		zztool -e arquivo_legivel "$arquivo" || continue

		# Remove o \r
		cp "$arquivo" "$tmp" &&
			sed "s/$control_m*$//" "$tmp" >"$arquivo"

		# Segurança
		if test $? -ne 0; then
			zztool erro "Ops, algum erro ocorreu em $arquivo"
			zztool erro "Seu arquivo original está guardado em $tmp"
			return 1
		fi

		# Remove a permissão de execução, comum em arquivos DOS
		chmod -x "$arquivo"

		echo "Convertido $arquivo"
	done

	# Remove o arquivo temporário
	rm -f "$tmp"
}
