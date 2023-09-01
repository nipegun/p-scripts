#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para determinar el tipo de procesador a poner en las máquinas virtuales de Proxmox
#
# Ejecución remota:
#  curl -sL x | bash
#
# x86-64-v1 (kvm64) (Compatible con Intel Pentium 4 y AMD Phenom, o superiores).
#   flags: 
# x86-64-v2:        (Compatible con Intel Nehalem y AMD Opteron_G3, o superiores).
#   flags: cx16, lahf-lm, popcnt, pni, sse4.1, sse4.2, ssse3.
# x86-64-v2-AES:    (Compatible con Intel Westmere y AMD Opteron_G4, o superiores).
#   flags: cx16, lahf-lm, popcnt, pni, sse4.1, sse4.2, ssse3, aes.
# x86-64-v3:        (Compatible con Intel Broadwell y AMD EPYC, o superiores).
#   flags: cx16, lahf-lm, popcnt, pni, sse4.1, sse4.2, ssse3, aes, avx, avx2, bmi1, bmi2, f16c, fma, movbe, xsave.
# x86-64-v4:        (Compatible con Intel Skylake y AMD EPYC v4 Genoa, o superiores).
#   flags: cx16, lahf-lm, popcnt, pni, sse4.1, sse4.2, ssse3, aes, avx, avx2, bmi1, bmi2, f16c, fma, movbe, xsave, avx512f, avx512bw, avx512cd, avx512dq, avx512vl.
# ----------

vFlags=$(cat /proc/cpuinfo | grep flags | head -n 1 | cut -d: -f2)

vFlags-v2=$(cat /proc/cpuinfo | grep flags | head -n 1 | cut -d: -f2 | grep -E --color     ' cx16 | lahf_lm | popcnt | pni | sse4_1 | sse4_2 | ssse3 ')
vFlags-v2-AES=$(cat /proc/cpuinfo | grep flags | head -n 1 | cut -d: -f2 | grep -E --color ' cx16 | lahf_lm | popcnt | pni | sse4_1 | sse4_2 | ssse3 | aes ')
vFlags-v3=$(cat /proc/cpuinfo | grep flags | head -n 1 | cut -d: -f2 | grep -E --color     ' cx16 | lahf_lm | popcnt | pni | sse4_1 | sse4_2 | ssse3 | aes | avx | avx2 | bmi1 | bmi2 | f16c | fma | movbe | xsave ')

vSupports_v2='awk "/cx16/&&/lahf_lm/&&/popcnt/&&/pni/&&/sse4_1/&&/sse4_2/&&/ssse3/       {found=1} END {exit !found}"'
vSupports_v3='awk "/avx/&&/avx2/&&/bmi1/&&/bmi2/&&/f16c/&&/fma/&&/abm/&&/movbe/&&/xsave/ {found=1} END {exit !found}"'
vSupports_v4='awk "/avx512f/&&/avx512bw/&&/avx512cd/&&/avx512dq/&&/avx512vl/             {found=1} END {exit !found}"'
 
echo "$vFlags" | eval $vSupports_v2 || exit 2 && echo "Se puede usar: x86-64-v2"
echo "$vFlags" | eval $vSupports_v3 || exit 3 && echo "Se puede usar: x86-64-v3"
echo "$vFlags" | eval $vSupports_v4 || exit 4 && echo "Se puede usar: x86-64-v4"

