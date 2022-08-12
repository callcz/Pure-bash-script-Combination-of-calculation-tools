#/bin/bash
# This is an division calculator shell script,
# that supports negative and positive decimal numbers.
# Written by callcz 20220808.
if [[ $1 == --help || $1 == -h || ! $1 ]]
then
	head -n 4 $0
	echo "Usage: $0 [DIVIDEND] [DIVISOR] [SCALE] [OPSTIONS]
	Default SCALE val is '12'
Options:
	%	Output Quotient.
	/	Output Remainder.
	--uround,-ur Don't rounding after decimal point.
	--help List this help.
"
	exit
fi
dividend=$1
divisor=$2
if [[ $1 -eq 0 ]] 2>/dev/null
then
	echo 0
	exit
elif [[ $2 -eq 0 ]] 2>/dev/null
then
	echo 'Divide by zero!' 1>&2
	exit 3
fi

if [ $3 -ge 0 ] 2>/dev/null
then
	scale=$3
else
	scale=${scale:=12}
fi

for i in $*
do
	if [[ $i == '%' || $i == '/' ]]
	then
		scale=0
		check_per=1
		check_2=1
	else
		scale=${scale:=12}
	fi
	if [[ $i == -ur || $i == --uround || $check_per == 1 ]]
	then
		round='null'
		scale=$[scale-1]
		scale_=$scale
		if [[ $scale -le 0 ]] 1>&2
		then
			scale=0
			check_per=1
		fi
	else
		round='4/5'
	fi
done
beichu=$dividend
chu=$divisor
reg=($*)
minus=0
yu=
unset_l(){
	for i in {a..z}
	do
	eval unset $i
	done
}
#处理小数负数
for ((i=0;i<2;i++))
do
	j=${reg[$i]}
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
	reg[$i]=${zhengshu[$i]}${xiaoshu[$i]}
done
#test echo
#echo reg=${reg[@]}
#echo zhengshu=${zhengshu[@]}
#echo xiaoshu=${xiaoshu[@]}
#echo xiaoshuwei=${xiaoshuwei[@]}
#unset_l
if [[ ${xiaoshuwei[0]} -gt ${xiaoshuwei[1]} ]]
then
	xiaoshuwei=${xiaoshuwei[0]}
else
	xiaoshuwei=${xiaoshuwei[1]}
fi
for i in 0 1
do
	while [[ ${#xiaoshu[$i]} -lt $xiaoshuwei ]]
	do
		xiaoshu[$i]=${xiaoshu[$i]}0
		reg[$i]=${zhengshu[$i]}${xiaoshu[$i]}
	done
	while [[ ${reg[$i]:0:1} -eq 0 && ${#reg[$i]} -ne 1 ]]
	do
		reg[$i]=${reg[$i]:1}
	done
done
#echo reg=${reg[@]}
#unset_l
#计算
beichu=${reg[0]}
chu=${reg[1]}
beichu_=$beichu_${beichu:${n:=0}:1}
beichu_n=${#beichu}
xiaoshuwei_=0
while :
do
	if [[ $scale ]]
	then
		if [[ $scale -lt $xiaoshuwei_ ]]
		then
			break
		fi
	fi
	if [[ $yu == 0 && ${beichu:$[n+1]} -eq 0 && $check_per -ne 1 ]]
	then
#		echo $n $beichu_ $beichu ${beichu:$[n+1]}
		zhi=$zhi${beichu:$[n+1]}
#		echo $zhi
		break
	elif [[ $yu ]]
	then
		beichu_=$yu
		#beichu_=$beichu_${beichu:$n:1}
		check_yu=1
	fi
#	echo $yu $scale
#	echo $beichu_
#	sleep 1
	while [[ $beichu_ -lt $chu && $xiaoshuwei_ -le $scale ]]
	do
		if [[ $check_yu -ne 1 ]]
		then
			zhi=${zhi}0
		else
			check_yu=0
		fi
		((n++))
#		echo "n=$n #beichu=${#beichu}"
		if [[ $n -ge ${#beichu} ]]
		then
#			echo $n -ge ${#beichu}
			beichu=${beichu}0
			if [[ ! $dot ]]
			then
				for check_ in $*
				do
#					echo $check_
					if [[ $check_ == '%' ]]
					then
						check_1=`./addition_core.sh ${reg[0]} -${reg[1]}`
#						if [[ ${reg[0]} -ge ${reg[1]} ]]
						if [[ ${check_1:0:1} != '-' ]]
						then
							yu=`./addition_core.sh $1 -$(./multiplication_core.sh $zhi $2)`
							echo $yu
						else
							echo $1
						fi
					fi
					if [[ $check_ == '/' ]]
					then
						while [[ ${zhi:0:1} == 0 && ${#zhi} -ne 1 ]]
						do
							zhi=${zhi:1}
						done
						echo $zhi
					fi
					if [[ $check_ == -ur && $scale -eq 0 && $check_2 -ne 1 ]]
					then
						while [[ ${zhi:0:1} == 0 && ${#zhi} -ne 1 ]]
						do
							zhi=${zhi:1}
						done
						echo $zhi
					fi
				done
				if [[ $check_per -eq 1 ]]
				then
					exit
				fi
				zhi=${zhi}.
			fi
			dot=1
			((xiaoshuwei_++))
		fi
#		echo $beichu_
		beichu_=$beichu_${beichu:${n:=0}:1}
#		echo $beichu_
		while [[ ${beichu_:0:1} -eq 0 && ${#beichu_} -ne 1 ]]
		do
			beichu_=${beichu_:1}
		done
#		sleep 1
#		echo zhi=$zhi
		unset yu
	done
	unset j
	for ((i=1;i<=10;i++))
	do
		j=${j:-0}
		if [[ $i -eq 10 ]]
		then
			jian[$j]=${chu}0
		else
			jian[$j]=`./multiplication_core.sh $chu $i`
		fi
		if [[ ${jian[$j]} -eq $beichu_ ]]
		then
			jian=${jian[$j]}
			zhi=$zhi$i
			yu=`./addition_core.sh $beichu_ "-$jian"`
			break
		elif [[ ${jian[$j]} -gt $beichu_ ]]
		then
			jian=${jian[$[j-1]]}
			zhi=$zhi$j
			yu=`./addition_core.sh $beichu_ "-$jian"`
			break
		fi
		((j++))
	done
done
#echo *zhi=$zhi xiaoshuwei_=$xiaoshuwei_ scale=$scale minus=$minus 1>&2
#echo scale=$scale round=$round 1>&2
while [[ ${zhi:0:1} -eq 0 && ${#zhi} -ne 1 && ${zhi:0:2} != '0.' ]]
do
	zhi=${zhi:1}
done
#rounding
if [[ $round == '4/5' && $xiaoshuwei_ -gt $scale ]]
then
#	echo "rounding function be under construction" 1>&2
	zhi_xiaoshu=${zhi#*.}
	while [[ ${#zhi_xiaoshu} -lt $xiaoshuwei_  && $zhi != ${zhi#*.} ]]
	do
		zhi=${zhi}0
		zhi_xiaoshu=${zhi#*.}
	done
	unset j
	for ((i=0;i<$xiaoshuwei_;i++))
	do
		if [[ $i == 0 ]]
		then
			j=1
		else
			j=0${j:-1}
		fi
	done
	if [[ $j != 1  ]]
	then
		j=0.${j#0}
	fi
#	echo j=$j
	if [[ ${zhi_xiaoshu:0-1} -ge 5 ]]
	then
		round=up
		zhi=${zhi:0:$[${#zhi}-1]}
		zhi=`./addition_core.sh $zhi $j`
	else
		round=down
		zhi=${zhi:0:$[${#zhi}-1]}
	fi
elif [[ $xiaoshuwei_ -gt $scale ]]
then
#	round=null
	scale=$[scale_+1]
fi
if [[ ${zhi:0-1} == '.' ]]
then
	zhi=${zhi%.}
fi
if [[ $minus == 1 ]]
then
	zhi_f='-'$zhi
else
	zhi_f=$zhi
fi
echo scale=$scale rounding=$round 1>&2
echo $zhi_f
exit
