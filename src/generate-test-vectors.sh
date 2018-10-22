#!/bin/sh

set -e
set -u

MALE_SAMPLE=male.wav
FEMALE_SAMPLE=female.wav
WB_MALE_SAMPLE=wb_male.wav
mkdir -p test-vectors

samples="${MALE_SAMPLE} ${FEMALE_SAMPLE} ${WB_MALE_SAMPLE}"
for sample in $samples; do
    wget --no-clobber https://www.speex.org/samples/audio/${sample}
done

bitrates="4 8 11 15"
for b in $bitrates; do
    kbitrate=$(expr $b \* 1000)
    ./speexenc --narrowband --bitrate ${kbitrate}  ${MALE_SAMPLE} test-vectors/male_speex_${b}.spx
    ./speexenc --narrowband --bitrate ${kbitrate} --vbr ${MALE_SAMPLE} test-vectors/male_speex_${b}_vbr.spx
    ./speexenc --narrowband --bitrate ${kbitrate} ${FEMALE_SAMPLE} test-vectors/female_speex_${b}.spx
    ./speexenc --narrowband --bitrate ${kbitrate} --vbr ${FEMALE_SAMPLE} test-vectors/female_speex_${b}_vbr.spx
done

bitrates="10 12 17 18 21 28"
for b in $bitrates; do
    kbitrate=$(expr $b \* 1000)
    ./speexenc --wideband --bitrate ${kbitrate}  ${WB_MALE_SAMPLE} test-vectors/wb_male_speex_${b}.spx
    ./speexenc --wideband  --bitrate ${kbitrate} --vbr ${WB_MALE_SAMPLE} test-vectors/wb_male_speex_${b}_vbr.spx
done
