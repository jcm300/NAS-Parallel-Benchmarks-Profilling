#!/bin/bash

resFolder="res.txt"

function getStats(){
    echo "$1" | sort -n | awk 'BEGIN {c = 0}
                                $1 ~ /^[0-9]*((\.|,)[0-9]*)?$/ {
                                a[c] = $1;
                                c++;
                             }
                             END {
                                if((c % 2) == 1){
                                    median = a[int(c/2)];
                                }else{
                                    median = ( a[c/2] + a[c/2-1] ) / 2;
                                }
                                if(a[0]=="") a[0]="und";
                                if(a[c-1]=="") a[c-1]="und";
                                if(median=="") median="und";
                                print median " " a[0] " " a[c-1];
                             }'
}

function initiate(){
    cpu_pidstat_cpu=()
    cpu_sar_iowait=()
    cpu_sar_idle=()
    cpu_sar_system=()
    cpu_sar_user=()
    disk_iostat_Blk_read=()
    disk_iostat_Blk_wrtn=()
    disk_vmstat_reads_merged=()
    disk_vmstat_reads_ms=()
    disk_vmstat_writes_merged=()
    disk_vmstat_writes_ms=()
    disk_vmstat_io_cur=()
    disk_vmstat_io_sec=()
    mem_pidstat_mem=()
    mem_sar_memused=()
    mem_vmstat_swpd=()
    mem_vmstat_free=()
    mem_vmstat_buff=()
    mem_vmstat_cache=()
    mem_vmstat_si=()
    mem_vmstat_so=()
    network_saturation_rxdrop=()
    network_saturation_txdrop=()
    network_saturation_rxfifo=()
    network_saturation_txfifo=()
    network_usage_rxpck=()
    network_usage_txpck=()
    network_usage_rxkB=()
    network_usage_txkB=()
    network_usage_rxmcst=()
}

function processOneCase(){
    #cpu_pidstat %cpu
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($8 ~ /(ft|lu-mz)\.(A|B)\.(x|\d+)/){print $6}}' $1/cpu_pidstat.txt)
    cpu_pidstat_cpu+=($(getStats "$aux"))

    #cpu_sar %iowait
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($6 ~ /[0-9]+\.[0-9]+/){print $6}}' $1/cpu_sar.txt)
    cpu_sar_iowait+=($(getStats "$aux"))

    #cpu_sar %idle
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($8 ~ /[0-9]+\.[0-9]+/ && $7 ~ /[0-9]+\.[0-9]+/){print $8}}' $1/cpu_sar.txt)
    cpu_sar_idle+=($(getStats "$aux"))

    #cpu_sar %system
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($5 ~ /[0-9]+\.[0-9]+/){print $5}}' $1/cpu_sar.txt)
    cpu_sar_system+=($(getStats "$aux"))

    #cpu_sar %user
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($3 ~ /[0-9]+\.[0-9]+/){print $3}}' $1/cpu_sar.txt)
    cpu_sar_user+=($(getStats "$aux"))

    #disk_iostat Blk_read/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($3 ~ /[0-9]+\.[0-9]+/){print $3}}' $1/disk_iostat.txt)
    disk_iostat_Blk_read+=($(getStats "$aux"))

    #disk_iostat Blk_wrtn/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($4 ~ /[0-9]+\.[0-9]+/){print $4}}' $1/disk_iostat.txt)
    disk_iostat_Blk_wrtn+=($(getStats "$aux"))

    #disk_vmstat reads_merged
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){print $3}}' $1/disk_vmstat.txt)
    disk_vmstat_reads_merged+=($(getStats "$aux"))

    #disk_vmstat reads_ms
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){print $5}}' $1/disk_vmstat.txt)
    disk_vmstat_reads_ms+=($(getStats "$aux"))

    #disk_vmstat writes_merged
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){print $7}}' $1/disk_vmstat.txt)
    disk_vmstat_writes_merged+=($(getStats "$aux"))

    #disk_vmstat writes_ms
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){print $9}}' $1/disk_vmstat.txt)
    disk_vmstat_writes_ms+=($(getStats "$aux"))

    #disk_vmstat io_cur
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){print $10}}' $1/disk_vmstat.txt)
    disk_vmstat_io_cur+=($(getStats "$aux"))

    #disk_vmstat io_sec
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){print $11}}' $1/disk_vmstat.txt)
    disk_vmstat_io_sec+=($(getStats "$aux"))

    #mem_pidstat %mem
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($8 ~ /(ft|lu-mz)\.(A|B)\.(x|\d+)/){print $7}}' $1/mem_pidstat.txt)
    mem_pidstat_mem+=($(getStats "$aux"))

    #mem_sar %memused
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($4 ~ /[0-9]+\.[0-9]+/){print $4}}' $1/mem_sar.txt)
    mem_sar_memused+=($(getStats "$aux"))

    #mem_vmstat swpd
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($4 ~ /[0-9]+/){print $4}}' $1/mem_vmstat.txt)
    mem_vmstat_swpd+=($(getStats "$aux"))

    #mem_vmstat free
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($5 ~ /[0-9]+/){print $5}}' $1/mem_vmstat.txt)
    mem_vmstat_free+=($(getStats "$aux"))
    
    #mem_vmstat buff
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($6 ~ /[0-9]+/){print $6}}' $1/mem_vmstat.txt)
    mem_vmstat_buff+=($(getStats "$aux"))

    #mem_vmstat cache
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($7 ~ /[0-9]+/){print $7}}' $1/mem_vmstat.txt)
    mem_vmstat_cache+=($(getStats "$aux"))

    #mem_vmstat si
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($8 ~ /[0-9]+/){print $8}}' $1/mem_vmstat.txt)
    mem_vmstat_si+=($(getStats "$aux"))

    #mem_vmstat so
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($9 ~ /[0-9]+/){print $9}}' $1/mem_vmstat.txt)
    mem_vmstat_so+=($(getStats "$aux"))
    mem_vmstat_so+=(' ')

    #network_saturation rxdrop/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /(eth|myri)\d/){print $6}}' $1/network_saturation_sar.txt)
    network_saturation_rxdrop+=($(getStats "$aux"))

    #network_saturation txdrop/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /(eth|myri)\d/){print $7}}' $1/network_saturation_sar.txt)
    network_saturation_txdrop+=($(getStats "$aux"))

    #network_saturation rxfifo/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /(eth|myri)\d/){print $10}}' $1/network_saturation_sar.txt)
    network_saturation_rxfifo+=($(getStats "$aux"))

    #network_saturation txfifo/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /(eth|myri)\d/){print $11}}' $1/network_saturation_sar.txt)
    network_saturation_txfifo+=($(getStats "$aux"))

    #network_usage rxpck/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /(eth|myri)\d/){print $3}}' $1/network_usage_sar.txt)
    network_usage_rxpck+=($(getStats "$aux"))

    #network_usage txpck/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /(eth|myri)\d/){print $4}}' $1/network_usage_sar.txt)
    network_usage_txpck+=($(getStats "$aux"))

    #network_usage rxkB/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /(eth|myri)\d/){print $5}}' $1/network_usage_sar.txt)
    network_usage_rxkB+=($(getStats "$aux"))

    #network_usage txkB/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /(eth|myri)\d/){print $6}}' $1/network_usage_sar.txt)
    network_usage_txkB+=($(getStats "$aux"))

    #network_usage rxmcst/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /(eth|myri)\d/){print $9}}' $1/network_usage_sar.txt)
    network_usage_rxmcst+=($(getStats "$aux"))
}

function processFlags(){
    processOneCase "$2/GNU_2_0_$1_results" 
    processOneCase "$2/GNU_3_0_$1_results" 
    processOneCase "$2/GNU_F_0_$1_results" 
    processOneCase "$2/INTEL_2_0_$1_results" 
    processOneCase "$2/INTEL_3_0_$1_results" 
    processOneCase "$2/INTEL_F_0_$1_results" 
}

function processClass(){
    processFlags "A" "NPB3.3-SER"
    processFlags "B" "NPB3.3-SER"
    processFlags "A" "NPB3.3-OMP"
    processFlags "B" "NPB3.3-OMP"
    processFlags "A" "NPB3.3-MPI"
    processFlags "B" "NPB3.3-MPI"

    echo -e "%CPU:" '\t' "%iowait:" '\t' "%idle:" '\t' "%system:" '\t' "%user:" '\t' "Blk_read/s:" '\t' "Blk_wrtn/s:" '\t' "reads_merged:" '\t' "reads_ms:" '\t' "writes_merged:" '\t' "writes_ms:" '\t' "io_cur:" '\t' "io_sec:" '\t' "%MEM:" '\t' "%memused:" '\t' "swpd:" '\t' "free:" '\t' "buff:" '\t' "cache:" '\t' "si:" '\t' "so:" '\t' "rxdrop/s:" '\t' "txdrop/s:" '\t' "rxfifo/s:" '\t' "txfifo/s:" '\t' "rxpck/s:" '\t' "txpck/s:" '\t' "rxkB/s:" '\t' "txkB/s:" '\t' "rxmcst/s:" > $resFolder

    length=${#cpu_pidstat_cpu[@]}

    for (( i=0; i<${length}; i++ ));
    do
        echo -e ${cpu_pidstat_cpu[$i]} '\t' ${cpu_sar_iowait[$i]} '\t' ${cpu_sar_idle[$i]} '\t' ${cpu_sar_system[$i]} '\t' ${cpu_sar_user[$i]} '\t' ${disk_iostat_Blk_read[$i]} '\t' ${disk_iostat_Blk_wrtn[$i]} '\t' ${disk_vmstat_reads_merged[$i]} '\t' ${disk_vmstat_reads_ms[$i]} '\t' ${disk_vmstat_writes_merged[$i]} '\t' ${disk_vmstat_writes_ms[$i]} '\t' ${disk_vmstat_io_cur[$i]} '\t' ${disk_vmstat_io_sec[$i]} '\t' ${mem_pidstat_mem[$i]} '\t' ${mem_sar_memused[$i]} '\t' ${mem_vmstat_swpd[$i]} '\t' ${mem_vmstat_free[$i]} '\t' ${mem_vmstat_buff[$i]} '\t' ${mem_vmstat_cache[$i]} '\t' ${mem_vmstat_si[$i]} '\t' ${mem_vmstat_so[$i]} '\t' ${network_saturation_rxdrop[$i]} '\t' ${network_saturation_txdrop[$i]} '\t' ${network_saturation_rxfifo[$i]} '\t' ${network_saturation_txfifo[$i]} '\t' ${network_usage_rxpck[$i]} '\t' ${network_usage_txpck[$i]} '\t' ${network_usage_rxkB[$i]} '\t' ${network_usage_txkB[$i]} '\t' ${network_usage_rxmcst[$i]} >> $resFolder
    done
}

initiate
processClass
