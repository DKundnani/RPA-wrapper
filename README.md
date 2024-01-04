
<h1 align="center">RPA-wrapper</h1>
<a href="https://github.com/xph9876/RibosePreferenceAnalysis">[Ribose Preferred Analysis</a>
<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!--
-->
[![Commits][Commits-shield]][Commits-url]
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Website][website-shield]][website-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="##Installation">Installation</a></li>
      <ul>
        <li><a href="###Getting-the-code">Getting the code</a></li>
        <li><a href="###Creating-the-enviroment-with-required-dependencies">Creating the enviroment with required dependencies</a></li>
        <li><a href="###Additional-Dependencies">Additional Dependencies</a></li>
      </ul>
    </li>
    <li><a href="##Usage">Usage</a></li>
      <ul>
        <li><a href="###Defining-variables">Defining variables</a></li>
        <li><a href="###Normalization-of-bed-files-for-coverage-(optional)">Normalization of bed files for coverage (optional)</a></li>
        <li><a href="###Generating-matrix">Generating matrix</a></li>
       <li><a href="###Getting-common-hotspots-for-each-genotype-using-different-thresholds-and-visualization">Getting common hotspots for each genotype using different thresholds and visualization</a></li>
        <li><a href="###GGseqlogo-plots-(MEME plots)">GGseqlogo plots (MEME plots)</a></li>
        <li><a href="###Additional-visualizations">Additional visualizations</a></li>
      </ul>
    <li><a href="##Contributing">Contributing</a></li>
    <li><a href="##License">License</a></li>
    <li><a href="##Contact">Contact</a></li>
    <li><a href="##Citations">Citations</a></li>
  </ol>
</details>

<!-- Installation -->
## Installation
### Getting the code
The development version from [GitHub](https://github.com/) with:
```sh
git clone https://github.com/DKundnani/rNMP_hotspots.git
```
### Creating the enviroment with required dependencies
```sh
conda env create --name rNMPhotspots_env --file /rNMP_hotspots/yml/r_env.yml
```
### Additional Dependencies
* Input files (bed) containing single nucleotide locations, mainly for rNMP data. (another single nucleotide data can also be experimented on!)
* Reference genome files (.fa and .fai) of the organism being used(Also used to generate bed files)
* BAM files (optional) from DNA-seq pipelines See [https://github.com/DKundnani/Omics-pipelines](https://github.com/DKundnani/Omics-pipelines)

<!-- USAGE -->
## Usage
### Defining variables
```bash
lib=path/to/AGS/ribo-DNA-order #First col Library name, 3rd col basename of bam files from DNA-se pipeline, 
bed=path/to/AGS/bed
dna=path/to/AGS/DNAseq/aligned
normbed=path/to/AGS/norm_counts
script=path/to/AGS/rNMP_hotspots
genome=path/to/reference/sacCer2/sacCer2-nucl.fa.fai #size file of the genome
```
### Normalization of bed files for coverage (optional)
```bash
conda activate rNMPhotspots_env #activating enviroment
mkdir $normbed #Creating output directory

while read -r line;
do
   FS=$(echo $line | tr " " "\t" | cut -f1)
   sam=$(echo $line| sed 's/\r$//' | awk '{print $3}') 
Rscript $script/count_norm.R -r $bed/*.bed -c ${dna}/${sam}.cov -g $genome -o $normbed ;
done < $lib > $normbed/norm.log

```
### Generating matrix
```bash
mkdir $normbed/hotspots #place files into the normbed folder
cd $normbed
#getting files per genotype
filelist=$(cut -f3 files | uniq | tr "\n" "\t")
for f in $filelist; do grep $f files > ${f}_files; done 

thresh=2 #Minimum 2 libraries in each subtype used as threshold
for f in $filelist; do $script/df_matrix.R -f ${f}_files -a -t $thresh -c 8 -s -o ${f}_files_${thresh}_common_EF.tsv & done #files contain library information per genotype to be grouped for finding hotspots
```
### Getting common hotspots for each genotype using different thresholds and visualization
```bash
mv *tsv* ./hotspots/
cd hotspots
top=25 #Getting top 25 hotspots
for f in $filelist; do Rscript $script/plot_hotspots.R -m ${f}_files*all -c -g $genome -r BSgenome.Scerevisiae.UCSC.sacCer2 -t $top -v -o . & done

#Getting top fraction of hotspots
for thresh in 0.05 0.02 0.01 ; do
for f in $filelist; do Rscript $script/plot_hotspots.R -m ${f}_files*all -c -g $genome -r BSgenome.Scerevisiae.UCSC.sacCer2 -t $thresh -o . & done
done

```
### GGseqlogo plots (MEME plots)
```bash
for thresh in 0.05 0.02 0.01 ; do
for f in $filelist; do Rscript $script/meme.R -f ${f}_files*${thresh}*top* -c 9 & done #ggseqlogo plots
done
```
### Additional visualizations
See stacked barplots for composition in [RPA-wrapper](https://github.com/DKundnani/RPA-wrapper)


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact
Deepali L. Kundnani - [deepali.kundnani@gmail.com](mailto::deepali.kundnani@gmail.com)    [![LinkedIn][linkedin-shield]][linkedin-url] 
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Citations
Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!+
* <b> Distinct features of ribonucleotides within genomic DNA in Aicardi-Goutières syndrome (AGS)-ortholog mutants of <i>Saccharomyces cerevisiae</i> </b>
Deepali L. Kundnani, Taehwan Yang, Alli L. Gombolay, Kuntal Mukherjee, Gary Newnam, Chance Meers, Zeel H. Mehta, Celine Mouawad, Francesca Storici
bioRxiv 2023.10.02.560505; doi:[https://doi.org/10.1101/2023.10.02.560505]( https://doi.org/10.1101/2023.10.02.560505)
* Kundnani, D. (2024). rNMP_hotspots:2.0.0 (2.0.0). Zenodo.  [https://doi.org/10.5281/zenodo.8152090](https://doi.org/10.5281/zenodo.8152090) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8152090.svg)](https://doi.org/10.5281/zenodo.8152090)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/DKundnani/RPA-wrapper?style=for-the-badge
[contributors-url]: https://github.com/DKundnani/RPA-wrapper/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/DKundnani/RPA-wrapper?style=for-the-badge
[forks-url]: https://github.com/DKundnani/RPA-wrapper/forks
[stars-shield]: https://img.shields.io/github/stars/DKundnani/RPA-wrapper?style=for-the-badge
[stars-url]: https://github.com/DKundnani/RPA-wrapper/stargazers
[issues-shield]: https://img.shields.io/github/issues/DKundnani/RPA-wrapper?style=for-the-badge
[issues-url]: https://github.com/DKundnani/RPA-wrapper/issues
[license-shield]: https://img.shields.io/github/license/DKundnani/RPA-wrapper?style=for-the-badge
[license-url]: https://github.com/DKundnani/RPA-wrapper/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/deepalik
[product-screenshot]: images/screenshot.png
[commits-url]: https://github.com/DKundnani/RPA-wrapper/pulse
[commits-shield]: https://img.shields.io/github/commit-activity/t/DKundnani/RPA-wrapper?style=for-the-badge
[website-shield]: https://img.shields.io/website?url=http%3A%2F%2Fdkundnani.bio%2F&style=for-the-badge
[website-url]:http://dkundnani.bio/ 
