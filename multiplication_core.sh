#/bin/bash
# This is an multiplication calculator shell script,
# that supports negative and positive decimal numbers.
# Written by callcz 20220808.
if [[ $1 == --help || $1 == -h || ! $1 ]]
then
	head -n 4 $0
	echo "Usage: $0 [MULTIPLICAND] [MULTIPLIER]"
	exit
fi
yin_proto=($1 $2)
yin=($1 $2)
minus=0
unset_l(){
	for i in {a..z}
	do
	eval unset $i
	done
}
#处理小数负数
for ((i=0;i<2;i++))
do
	j=${yin[$i]}
	if [[ ${j:0:1} == '-' ]]
	then
		((minus++))
		j=${j#-}
	fi
	if [[ ${j#*.} != $j ]]
	then
		zhengshu[$i]=${j%.*}
		xiaoshu[$i]=${j#*.}
		while [[ ${xiaoshu[$i]:0-1} -eq 0 && ${xiaoshu[$i]} -ne 0 ]]
		do
			xiaoshu[$i]=${xiaoshu[$i]:0:$[${#xiaoshu[$i]}-1]}
		done
		xiaoshuwei[$i]=${#xiaoshu[$i]}
	else
		zhengshu[$i]=$j
		xiaoshu[$i]=
		xiaoshuwei[$i]=0
	fi
	yin[$i]=${zhengshu[$i]}${xiaoshu[$i]}
	while [[ ${yin[$i]:0:1} -eq 0 && ${#yin[$i]} -ne 1 ]]
	do
		yin[$i]=${yin[$i]:1}
	done
done
xiaoshuwei=$[${xiaoshuwei[0]}+${xiaoshuwei[1]}]
unset_l
#计算
#zhi_t=$(expr ${yin[0]} \* ${yin[1]})
n0=${#yin[0]}
n1=${#yin[1]}
for ((i1=1;i1<=n1;i1++))
do
	k=${k:-0}
	j1=${yin[1]:0-$i1:1}
	for ((i0=1;i0<=n0;i0++))
	do
		j0=${yin[0]:0-$i0:1}
		zhi_proto=$[j1*j0]
		zhi_plus=$[zhi_proto+${zhi_shi:-0}]
		#echo $j1 $j0 $zhi_proto $zhi_plus
		if [[ $zhi_plus -ge 10 ]]
		then
			zhi_ge=${zhi_plus:0-1}
			zhi_shi=${zhi_plus:0:$[${#zhi_plus}-1]}
		else
			zhi_ge=$zhi_plus
			zhi_shi=
		fi
		zhi_=$zhi_ge$zhi_

	done
	zhi[$k]=$zhi_shi$zhi_
	unset zhi_
	unset zhi_shi
	((k++))
done
for ((i=0;i<${#zhi[@]};i++))
do
	zhi[$i]=${zhi[$i]}$zero
	zero=${zero}0
done

for i in ${zhi[@]}
do
	zhi_f=$(./addition_core.sh $zhi_f $i)
done
#处理小数位
while [[ $xiaoshuwei -ge ${#zhi_f} ]]
do
	zhi_f=0$zhi_f
done
zhi_f_xiaoshu=${zhi_f:0-$xiaoshuwei}
if [[ $xiaoshuwei -ne 0 ]]
then
	zhi_f_zhengshu=${zhi_f:0:$[${#zhi_f}-$xiaoshuwei]}
	while [[ ${zhi_f_xiaoshu:0-1} -eq 0 && ${#zhi_f_xiaoshu} -ne 1 ]]
	do
		zhi_f_xiaoshu=${zhi_f_xiaoshu:0:$[${#zhi_f_xiaoshu}-1]}
	done
	zhi_f_xiaoshu_kz=$zhi_f_xiaoshu
	while [[ ${zhi_f_xiaoshu_kz:0:1} -eq 0 && ${#zhi_f_xiaoshu_kz} -ne 1 ]]
	do
		zhi_f_xiaoshu_kz=${zhi_f_xiaoshu_kz:1}
	done
	if [[ $zhi_f_xiaoshu_kz -eq 0 ]]
	then
		zhi_f=$zhi_f_zhengshu
	else
		zhi_f=$zhi_f_zhengshu.$zhi_f_xiaoshu
	fi
fi
#处理负数
if [[ $minus -eq 1 ]]
then
	zhi_f='-'$zhi_f
fi
echo $zhi_f
exit
