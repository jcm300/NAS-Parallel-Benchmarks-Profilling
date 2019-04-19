#!/bin/bash

resFolder="res.txt"

#cpu_pidstat %cpu
echo "%cpu:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($8 ~ /(is|lu-mz)\.(A|B)\.(x|\d+)/){sub(/\./,",",$6); print $6}}' cpu_pidstat.txt >> $resFolder
echo "" >> $resFolder

#cpu_sar %iowait
echo "%iowait:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($6 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$6); print $6}}' $1 cpu_sar.txt >> $resFolder
echo "" >> $resFolder

#cpu_sar %idle
echo "%idle:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($8 ~ /[0-9]+\.[0-9]+/ && $7 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$8); print $8}}' cpu_sar.txt >> $resFolder
echo "" >> $resFolder

#cpu_sar %system
echo "%system:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($5 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$5); print $5}}' cpu_sar.txt >> $resFolder
echo "" >> $resFolder

#cpu_sar %user
echo "%user:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($3 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$3); print $3}}' cpu_sar.txt >> $resFolder
echo "" >> $resFolder

#disk_iostat %Blk_read/s
echo "%Blk_read/s:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($3 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$3); print $3}}' disk_iostat.txt >> $resFolder
echo "" >> $resFolder

#disk_iostat %Blk_wrtn/s
echo "%Blk_wrtn/s:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($4 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$4); print $4}}' disk_iostat.txt >> $resFolder
echo "" >> $resFolder

#disk_vmstat %reads_merged
echo "%reads_merged:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){sub(/\./,",",$3); print $3}}' disk_vmstat.txt >> $resFolder
echo "" >> $resFolder

#disk_vmstat %reads_ms
echo "%reads_ms:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){sub(/\./,",",$5); print $5}}' disk_vmstat.txt >> $resFolder
echo "" >> $resFolder

#disk_vmstat %writes_merged
echo "%writes_merged:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){sub(/\./,",",$7); print $7}}' disk_vmstat.txt >> $resFolder
echo "" >> $resFolder

#disk_vmstat %writes_ms
echo "%writes_ms:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){sub(/\./,",",$9); print $9}}' disk_vmstat.txt >> $resFolder
echo "" >> $resFolder

#disk_vmstat %io_cur
echo "%io_cur:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){sub(/\./,",",$10); print $10}}' disk_vmstat.txt >> $resFolder
echo "" >> $resFolder

#disk_vmstat %io_sec
echo "%io_sec:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($1 ~ /sda/){sub(/\./,",",$11); print $11}}' disk_vmstat.txt >> $resFolder
echo "" >> $resFolder

#mem_pidstat %mem
echo "%mem:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($8 ~ /(is|lu-mz)\.(A|B)\.(x|\d+)/){sub(/\./,",",$7); print $7}}' mem_pidstat.txt >> $resFolder
echo "" >> $resFolder

#mem_sar %memused
echo "%memused:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($4 ~ /[0-9]+\.[0-9]+/){sub(/\./,",",$4); print $4}}' mem_sar.txt >> $resFolder
echo "" >> $resFolder

#mem_vmstat swpd
echo "%swpd:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($4 ~ /[0-9]+/){sub(/\./,",",$4); print $4}}' mem_vmstat.txt >> $resFolder
echo "" >> $resFolder

#mem_vmstat free
echo "%free:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($5 ~ /[0-9]+/){sub(/\./,",",$5); print $5}}' mem_vmstat.txt >> $resFolder
echo "" >> $resFolder

#mem_vmstat buff
echo "%buff:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($6 ~ /[0-9]+/){sub(/\./,",",$6); print $6}}' mem_vmstat.txt >> $resFolder
echo "" >> $resFolder

#mem_vmstat cache
echo "%cache:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($7 ~ /[0-9]+/){sub(/\./,",",$7); print $7}}' mem_vmstat.txt >> $resFolder
echo "" >> $resFolder

#mem_vmstat si
echo "%si:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($8 ~ /[0-9]+/){sub(/\./,",",$8); print $8}}' mem_vmstat.txt >> $resFolder
echo "" >> $resFolder

#mem_vmstat so
echo "%so:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($9 ~ /[0-9]+/){sub(/\./,",",$9); print $9}}' mem_vmstat.txt >> $resFolder
echo "" >> $resFolder

#network_saturation rxdrop/s
echo "%rxdrop/s:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$6); print $6}}' network_saturation_sar.txt >> $resFolder
echo "" >> $resFolder

#network_saturation txdrop/s
echo "%txdrop/s:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$7); print $7}}' network_saturation_sar.txt >> $resFolder
echo "" >> $resFolder

#network_saturation rxfifo/s
echo "%rxfifo/s:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$10); print $10}}' network_saturation_sar.txt >> $resFolder
echo "" >> $resFolder

#network_saturation txfifo/s
echo "%txfifo/s:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$11); print $11}}' network_saturation_sar.txt >> $resFolder
echo "" >> $resFolder

#network_usage rxpck/s
echo "%rxpck/s:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$3); print $3}}' network_usage_sar.txt >> $resFolder
echo "" >> $resFolder

#network_usage txpck/s
echo "%txpck/s:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$4); print $4}}' network_usage_sar.txt >> $resFolder
echo "" >> $resFolder

#network_usage rxkB/s
echo "%rxkB/s:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$5); print $5}}' network_usage_sar.txt >> $resFolder
echo "" >> $resFolder

#network_usage txkB/s
echo "%txkB/s:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$6); print $6}}' network_usage_sar.txt >> $resFolder
echo "" >> $resFolder

#network_usage rxmcst/s
echo "%rxmcst/s:" >> $resFolder
awk 'BEGIN {RS="\n"; FS="\\s+"} $0 != "" {if($2 ~ /eth1/){sub(/\./,",",$9); print $9}}' network_usage_sar.txt >> $resFolder
echo "" >> $resFolder
