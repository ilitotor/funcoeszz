#!/bin/bash
# 2010-12-22
# Aurelio Marinho Jargas
#
# Extrai informações sobre as funções
#
# Uso: metadata.sh <campo>
# Ex.: metadata.sh autor
#      metadata.sh versao

cd "$(dirname "$0")/.." || exit 1  # go to repo root

tab=$(echo -e '\t')

case "$1" in
	autor | a)
		IFS="$tab"
		grep '# Autor:' zz/*.sh off/*.sh |
		sed "s/:# Autor: /$tab/" |
		while read -r funcao meta
		do
			printf '%-25s %s\n' "$funcao" "$meta"
		done
	;;
	desde | d)
		grep '# Desde:' zz/*.sh off/*.sh |
		sed "s/:# Desde: /$tab/" |
		sed "s/\(.*\)$tab\(.*\)/\2$tab\1/" |
		sort
	;;
	vers[aã]o | v)
		grep '# Versão:' zz/*.sh off/*.sh |
		sed "s/:# Versão: /$tab/" |
		sed "s/\(.*\)$tab\(.*\)/\2$tab\1/"
	;;
	requisitos | r)
		IFS=':'
		grep '# Requisitos:' zz/*.sh off/*.sh |
		sed "s/:# Requisitos: /:/" |
		while read -r funcao meta
		do
			printf '%-25s %s\n' "$funcao" "$meta"
		done
	;;
	tags | t)
		IFS=':'
		grep '# Tags:' zz/*.sh off/*.sh |
		sed "s/:# Tags: /:/" |
		while read -r funcao meta
		do
			printf '%-25s %s\n' "$funcao" "$meta"
		done
	;;
	nota | n)
		IFS=':'
		grep '^# Nota: \(requer \|opcional \|(ou) \)' zz/*.sh off/*.sh |
		sed "s/:# Nota: /:/" |
		while read -r funcao meta
		do
			printf '%-25s %s\n' "$funcao" "$meta"
		done
	;;
esac
