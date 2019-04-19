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
                                print median;
                                print a[0];
                                print a[c-1];
                            }'
}

function printInfo(){
    echo "Info about output:" > $resFolder
    echo "    Metric" >> $resFolder
    echo "    Median" >> $resFolder
    echo "    Min" >> $resFolder
    echo "    Max" >> $resFolder
    echo "" >> $resFolder
}

function processOneCase(){
    #cpu_pidstat %cpu
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($8 ~ /(is|lu-mz)\.(A|B)\.(x|\d+)/){print $6}}' $1/cpu_pidstat.txt)
    cpu_pidstat_cpu+=$(getStats "$aux")
    cpu_pidstat_cpu+=$'\n'

    #cpu_sar %iowait
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($6 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$6); print $6}}' $1/cpu_sar.txt)
    cpu_sar_iowait+=$(getStats "$aux")
    cpu_sar_iowait+=$'\n'

    #cpu_sar %idle
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($8 ~ /[0-9]+\.[0-9]+/ && $7 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$8); print $8}}' $1/cpu_sar.txt)
    cpu_sar_idle+=$(getStats "$aux")
    cpu_sar_idle+=$'\n'

    #cpu_sar %system
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($5 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$5); print $5}}' $1/cpu_sar.txt)
    cpu_sar_system+=$(getStats "$aux")
    cpu_sar_system+=$'\n'

    #cpu_sar %user
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($3 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$3); print $3}}' $1/cpu_sar.txt)
    cpu_sar_user+=$(getStats "$aux")
    cpu_sar_user+=$'\n'

    #disk_iostat Blk_read/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($3 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$3); print $3}}' $1/disk_iostat.txt)
    disk_iostat_Blk_read+=$(getStats "$aux")
    disk_iostat_Blk_read+=$'\n'

    #disk_iostat Blk_wrtn/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($4 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$4); print $4}}' $1/disk_iostat.txt)
    disk_iostat_Blk_wrtn+=$(getStats "$aux")
    disk_iostat_Blk_wrtn+=$'\n'

    #disk_vmstat reads_merged
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){sub(/\./,",",$3); print $3}}' $1/disk_vmstat.txt)
    disk_vmstat_reads_merged+=$(getStats "$aux")
    disk_vmstat_reads_merged+=$'\n'

    #disk_vmstat reads_ms
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){sub(/\./,",",$5); print $5}}' $1/disk_vmstat.txt)
    disk_vmstat_reads_ms+=$(getStats "$aux")
    disk_vmstat_reads_ms+=$'\n'

    #disk_vmstat writes_merged
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){sub(/\./,",",$7); print $7}}' $1/disk_vmstat.txt)
    disk_vmstat_writes_merged+=$(getStats "$aux")
    disk_vmstat_writes_merged+=$'\n'

    #disk_vmstat writes_ms
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){sub(/\./,",",$9); print $9}}' $1/disk_vmstat.txt)
    disk_vmstat_writes_ms+=$(getStats "$aux")
    disk_vmstat_writes_ms+=$'\n'

    #disk_vmstat io_cur
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){sub(/\./,",",$10); print $10}}' $1/disk_vmstat.txt)
    disk_vmstat_io_cur+=$(getStats "$aux")
    disk_vmstat_io_cur+=$'\n'

    #disk_vmstat io_sec
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){sub(/\./,",",$11); print $11}}' $1/disk_vmstat.txt)
    disk_vmstat_io_sec+=$(getStats "$aux")
    disk_vmstat_io_sec+=$'\n'

    #mem_pidstat %mem
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($8 ~ /(is|lu-mz)\.(A|B)\.(x|\d+)/){sub(/\./,",",$7); print $7}}' $1/mem_pidstat.txt)
    mem_pidstat_mem+=$(getStats "$aux")
    mem_pidstat_mem+=$'\n'

    #mem_sar %memused
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($4 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$4); print $4}}' $1/mem_sar.txt)
    mem_sar_memused+=$(getStats "$aux")
    mem_sar_memused+=$'\n'

    #mem_vmstat swpd
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($4 ~ /[0-9]+/){sub(/\./,",",$4); print $4}}' $1/mem_vmstat.txt)
    mem_vmstat_swpd+=$(getStats "$aux")
    mem_vmstat_swpd+=$'\n'

    #mem_vmstat free
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($5 ~ /[0-9]+/){sub(/\./,",",$5); print $5}}' $1/mem_vmstat.txt)
    mem_vmstat_free+=$(getStats "$aux")
    mem_vmstat_free+=$'\n'
    
    #mem_vmstat buff
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($6 ~ /[0-9]+/){sub(/\./,",",$6); print $6}}' $1/mem_vmstat.txt)
    mem_vmstat_buff+=$(getStats "$aux")
    mem_vmstat_buff+=$'\n'

    #mem_vmstat cache
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($7 ~ /[0-9]+/){sub(/\./,",",$7); print $7}}' $1/mem_vmstat.txt)
    mem_vmstat_cache+=$(getStats "$aux")
    mem_vmstat_cache+=$'\n'

    #mem_vmstat si
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($8 ~ /[0-9]+/){sub(/\./,",",$8); print $8}}' $1/mem_vmstat.txt)
    mem_vmstat_si+=$(getStats "$aux")
    mem_vmstat_si+=$'\n'

    #mem_vmstat so
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($9 ~ /[0-9]+/){sub(/\./,",",$9); print $9}}' $1/mem_vmstat.txt)
    mem_vmstat_so+=$(getStats "$aux")
    mem_vmstat_so+=$'\n'

    #network_saturation rxdrop/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$6); print $6}}' $1/network_saturation_sar.txt)
    network_saturation_rxdrop+=$(getStats "$aux")
    network_saturation_rxdrop+=$'\n'

    #network_saturation txdrop/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$7); print $7}}' $1/network_saturation_sar.txt)
    network_saturation_txdrop+=$(getStats "$aux")
    network_saturation_txdrop+=$'\n'

    #network_saturation rxfifo/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$10); print $10}}' $1/network_saturation_sar.txt)
    network_saturation_rxfifo+=$(getStats "$aux")
    network_saturation_rxfifo+=$'\n'

    #network_saturation txfifo/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$11); print $11}}' $1/network_saturation_sar.txt)
    network_saturation_txfifo+=$(getStats "$aux")
    network_saturation_txfifo+=$'\n'

    #network_usage rxpck/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$3); print $3}}' $1/network_usage_sar.txt)
    network_usage_rxpck+=$(getStats "$aux")
    network_usage_rxpck+=$'\n'

    #network_usage txpck/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$4); print $4}}' $1/network_usage_sar.txt)
    network_usage_txpck+=$(getStats "$aux")
    network_usage_txpck+=$'\n'

    #network_usage rxkB/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$5); print $5}}' $1/network_usage_sar.txt)
    network_usage_rxkB+=$(getStats "$aux")
    network_usage_rxkB+=$'\n'

    #network_usage txkB/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$6); print $6}}' $1/network_usage_sar.txt)
    network_usage_txkB+=$(getStats "$aux")
    network_usage_txkB+=$'\n'

    #network_usage rxmcst/s
    aux=$(awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$9); print $9}}' $1/network_usage_sar.txt)
    network_usage_rxmcst+=$(getStats "$aux")
    network_usage_rxmcst+=$'\n'
}

function processFlags(){
    processOneCase "$2/GNU_2_0_$1_results" 
    processOneCase "$2/GNU_3_0_$1_results" 
    processOneCase "$2/GNU_F_0_$1_results" 
    processOneCase "$2/INTEL_2_0_$1_results" 
    processOneCase "$2/INTEL_3_0_$1_results" 
    processOneCase "$2/INTEL_F_0_$1_results" 
}

function printRes(){
    echo "$1" >> $resFolder
    echo "$2" >> $resFolder
    echo "" >> $resFolder
}

function processClass(){
    processFlags $1 "NPB3.3-SER"
    processFlags $1 "NPB3.3-OMP"
    processFlags $1 "NPB3.3-MPI"

    printRes "%CPU:" "$cpu_pidstat_cpu"
    printRes "%iowait:" "$cpu_sar_iowait"
    printRes "%idle:" "$cpu_sar_idle"
    printRes "%system:" "$cpu_sar_system"
    printRes "%user:" "$cpu_sar_user"
    printRes "Blk_read/s:" "$disk_iostat_Blk_read"
    printRes "Blk_wrtn/s:" "$disk_iostat_Blk_wrtn"
    printRes "reads_merged:" "$disk_vmstat_reads_merged"
    printRes "reads_ms:" "$disk_vmstat_reads_ms"
    printRes "writes_merged:" "$disk_vmstat_writes_merged"
    printRes "writes_ms:" "$disk_vmstat_writes_ms"
    printRes "io_cur:" "$disk_vmstat_io_cur"
    printRes "io_sec:" "$disk_vmstat_io_sec"
    printRes "%MEM:" "$mem_pidstat_mem"
    printRes "%memused:" "$mem_sar_memused"
    printRes "swpd:" "$mem_vmstat_swpd"
    printRes "free:" "$mem_vmstat_free"
    printRes "buff:" "$mem_vmstat_buff"
    printRes "cache:" "$mem_vmstat_cache"
    printRes "si:" "$mem_vmstat_si"
    printRes "so:" "$mem_vmstat_so"
    printRes "rxdrop/s:" "$network_saturation_rxdrop"
    printRes "txdrop/s:" "$network_saturation_txdrop"
    printRes "rxfifo/s:" "$network_saturation_rxfifo"
    printRes "txfifo/s:" "$network_saturation_txfifo"
    printRes "rxpck/s:" "$network_usage_rxpck"
    printRes "txpck/s:" "$network_usage_txpck"
    printRes "rxkB/s:" "$network_usage_rxkB"
    printRes "txkB/s:" "$network_usage_txkB"
    printRes "rxmcst/s:" "$network_usage_rxmcst"
}

printInfo
processClass $1
