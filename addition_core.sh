#/bin/bash
# This is an addition calculator shell script,
# that supports negative and positive decimal numbers.
# Written by callcz 20220807.
if [[ $1 == --help || $1 == -h || ! $1 ]]
then
	head -n 4 $0
	echo "Usage: $0 [SUMMAND] [ADDEND]"
	exit
fi
jia_proto=($1 $2)
jia=($1 $2)
minus=(0 0)
#unset val function
unset_l(){
for i in {a..z}
do
	unset $i
done
}
for ((i=0;i<2;i++))
do
	j=${jia[$i]}
	if [[ ${j:0:1} == '-' ]]
	then
		eval minus[$i]=1
		eval jia[$i]=${j#-}
	fi
done
#处理小数
for ((i=0;i<2;i++))
do
	j=${jia[$i]}
	if [[ ${j#*.} != $j ]]
	then
		zhengshu[$i]=${j%.*}
		xiaoshu[$i]=${j#*.}
		xiaoshuwei=${xiaoshuwei:-0}
		if [[ ${#xiaoshu[$i]} -gt $xiaoshuwei ]]
		then
			xiaoshuwei=${#xiaoshu[$i]}
		fi
		zhengshu=${zhengshu:-0}
	else
		zhengshu[$i]=$j
		xiaoshu[$i]=
		xiaoshuwei=${xiaoshuwei:-0}
	fi
done
unset j
for i in ${#xiaoshu[0]} ${#xiaoshu[1]}
do
	j=${j:-0}
	while [[ ${i} -lt $xiaoshuwei ]]
	do
		xiaoshu[$j]=${xiaoshu[$j]}0
		i=$[i+1]
	done
	j=$[j+1]
done
jia[0]=${zhengshu[0]}${xiaoshu[0]}
jia[1]=${zhengshu[1]}${xiaoshu[1]}
unset_l
#Subtraction
if [[ ${minus[@]} == '0 1' || ${minus[@]} == '1 0' ]]
then
	for ((i=0;i<${#jia[@]};i++))
	do
		eval j$i=${jia[$i]}
		eval jp$i=${jia_proto[$i]}
	done
	for z in $j0 $j1
	do
		x=${x:-0}
		while [[ ${z:0:1} -eq 0 && ${#z} -ne 1 ]]
		do
			z=${z:1}
		done
		eval z$x=$z
		x=$[x+1]
	done
	echo z0=$z0 ${#z0} 1>&2
	echo z1=$z1 ${#z1} 1>&2
	if [[ ${#z0} -gt 18 || ${#z1} -gt 18 ]]
	then
#		gt_cut=1
		if [[ ${#z0} -eq ${#z1} ]]
		then
			for ((i=0;i<=4095;i++))
			do
				o=$[i*19]
				p=19
				echo $o 1>&2
				echo $p 1>&2
				echo z0=${z0:$o:$p} 1>&2
				echo z1=${z1:$o:$p} 1>&2
				z3=${z0:$o:$p}
				z4=${z1:$o:$p}
				while [[ ${z3:0:1} -eq 0 && ${#z3} -ne 1 ]];do z3=${z3:1};done
				while [[ ${z4:0:1} -eq 0 && ${#z4} -ne 1 ]];do z4=${z4:1};done
				echo z3=$z3 1>&2
				echo z4=$z4 1>&2
				if [[ $z3 -gt $z4 ]]
				then
					ge=1
					break
				elif [[ $z3 -lt $z4 ]]
				then
					break
				fi
				if [[ ! $z3 ]]
				then
					ge=1
					break
				fi
			done
		elif [[ ${#z0} -gt ${#z1} ]]
		then
			ge=1
		fi
	elif [[ $z0 -ge $z1 ]]
	then
		ge=1
	fi
	if [[ $ge -eq 1 ]]
	then
		if [[ ${jp0:0:1} == '-' ]];then minus=1;else minus=0;fi
		big=$j0
		les=$j1
	else
		if [[ ${jp1:0:1} == '-' ]];then minus=1;else minus=0;fi
		big=$j1
		les=$j0
	fi
	n0=${#big}
	n1=${#les}
	echo big=$big 1>&2
	echo les=$les 1>&2
	if [[ $n0 -ge $n1 ]]
	then
		n=$n0
	else
		n=$n1
	fi
	for ((i=1;i<=$[n+1];i++))
	do
		jb=${big:0-$i:1}
		jl=${les:0-$i:1}
		jb=${jb:-0}
		jl=${jl:-0}
			if [[ $jb -ge $[jbo+jl] ]]
			then
				zhi=$[jb-jbo-jl]
				unset jbo
			else
				jb=1${jb}
				zhi=$[${jb}-jbo-jl]
				jbo=1
			fi
			zhi_f=$zhi$zhi_f
	done
	while [[ ${zhi_f:0:1} -eq 0 && ${#zhi_f} -ne 1 ]]
	do
		zhi_f=${zhi_f:1}
	done
fi
#Addition
if [[ ! $zhi_f ]]
then
	for ((i=0;i<${#jia[@]};i++))
	do
		eval n$i=${#jia[$i]}
	done
	if [[ $n0 -ge $n1 ]]
	then
		n=$n0
	else
		n=$n1
	fi
	for ((i=1;i<=$[n+1];i++))
	do
		j0=${jia[0]:0-$i:1}
		j1=${jia[1]:0-$i:1}
		j0=${j0:-0}
		j1=${j1:-0}
		if [[ $j2 ]]
		then
			zhi=$[j0+j1+j2]
		else
			zhi=$[j0+j1]
		fi
		unset j2
		if [[ $zhi -ge 10 ]];then j2=${zhi:0:1};fi
		zhi_f=${zhi:0-1}$zhi_f
	done
	if [[ ${minus[@]} == '1 1' ]];then minus=1;else minus=0;fi
fi
#处理小数
if [[ $xiaoshuwei -ne 0 ]]
then
	while [[ $xiaoshuwei -ge ${#zhi_f} ]]
	do
		zhi_f=0$zhi_f
	done
	zhi_f_zhengshu=${zhi_f:0:$[${#zhi_f}-$xiaoshuwei]}
	zhi_f_xiaoshu=${zhi_f:0-$xiaoshuwei}
	zhi_f_xiaoshu_kz=$zhi_f_xiaoshu
	while [[ ${zhi_f_xiaoshu_kz:0:1} -eq 0 && ${#zhi_f_xiaoshu_kz} -ne 1 ]]
	do
		zhi_f_xiaoshu_kz=${zhi_f_xiaoshu_kz:1}
	done
	if [[ $zhi_f_xiaoshu_kz -ne 0 ]]
	then
		while [[ ${zhi_f_xiaoshu:0-1} -eq 0 && ${#zhi_f_xiaoshu} -ne 1 ]]
		do
			zhi_f_xiaoshu=${zhi_f_xiaoshu:0:$[${#zhi_f_xiaoshu}-1]}
		done
		zhi_f=$zhi_f_zhengshu.$zhi_f_xiaoshu
	else
		zhi_f=$zhi_f_zhengshu
	fi
fi
#处理负数
while [[ ${zhi_f:0:1} -eq 0 && ${zhi_f:0:2} != '0.' && ${#zhi_f} -ne 1 ]]
do
	zhi_f=${zhi_f:1}
done
if [[ $minus -eq 1 ]]
then
	minus_f='-'
fi
zhi_f=$minus_f$zhi_f
echo $zhi_f
exit 0
