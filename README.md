
######################################################
# EN CONSTRUCCIÓN 
######################################################


# Análisis de amplicones del 16S rRNA con [Qiime2](https://qiime2.org/)



**Qiime2** (Quantitative Insights Into Microbial Ecology) es un *pipeline* desarrollado para el análisis de metataxonomía ([Bolyen et al., 2019](https://www.nature.com/articles/s41587-019-0209-9)). Contiene herramientas para limpiar secuencias, agrupar, asignar taxonomía, reconstruir filogenias, inferir métricas de diversidad, abundancia diferencial, etc. Es de código abierto, posee una [interfaz gráfica](https://view.qiime2.org/) amigable, [mucha documentación](https://docs.qiime2.org/2022.11/plugins/available/diversity/), [tutoriales](https://docs.qiime2.org/2023.7/tutorials/) y [foros de ayuda](https://forum.qiime2.org/).



Recordemos el flujo de análisis que se pueden hacer dentro de este *pipeline*.

<img src="https://github.com/DianaOaxaca/02.Amplicones_16S_Qiime2/blob/main/qiime2_wf.jpg" style="zoom:67%;" />



## Los datos

Para este taller trabajaremos con datos de amplicones de la región V3-V4 del 16S rRNA de muestras de tres tiempos de fermentación del **pulque**, estos se obtuvieron con una plataforma ILLUMINA MiSeq (2 x 300 pb) y están en formato FASTQ. Los datos fueron depositados en NCBI y ENA bajo el BioProject **PRJEB13870** del artículo **[Deep microbial community profiling along the fermentation process of pulque, a biocultural resource of Mexico](https://www.sciencedirect.com/science/article/pii/S0944501320304614#sec0010)** (Rocha-Arriaga et al., 2020).

Recordemos como es una secuencia en formato **fastq**:

**FASTQ**: Normalmente se compone de cuatro lineas por secuencia:

```
@HWI-D00525:129:C6ACWANXX:5:1106:11467:38087
TGTCAAGACAGGCACGCACGTTCTGAATCAGCCGACGGTCGGTACGTAAGGCCATGTATATCGTGGCGTCCTTGTAAGTGATTTCCTTGCGTCCG
+
CCCCCGGGGGGGGGGGGGGGGGGGGGGGGGGGGGDGGFGGGGGGGGGGGGGGGGGGGGGGGGGGGGFGGGGGGGGGFGGGGGFGGGGGGEDGGGG
```

- L1 Comienza con '@' seguido del identificador de la secuencia y una descripción opcional
- L2 La secuencia de nucleótidos
- L3 Comienza con un '+' opcionalmente incluye el identificador de la secuencia
- L4 Indica los valores de calidad de la secuencia, debe contener el mismo número de símbolos que el número de nucleótidos. (Actualmente se usa phred+33, puedes ver explicaciones más detalladas [aquí](https://en.wikipedia.org/wiki/Phred_quality_score). 





> **NOTA**: Cada programa tiene una ayuda y un manual de usuario, es **importante** revisarlo y conocer cada parámetro que se ejecute. En terminal se puede consultar el manual con el comando `man` y también se puede consultar la ayuda con `-h` o `--help`, por ejemplo `qiime tools import --help`.
>
> La presente práctica sólo es una representación del flujo de trabajo para el análisis de amplicones, sin embargo, no sustituye a los manuales de cada programa y el flujo puede variar dependiendo del tipo de datos y pregunta de investigación. Una explicación mucho más detallada de cada paso se encuentra en el *[overview](https://docs.qiime2.org/2023.7/tutorials/overview/)*  y en el *[moving-pictures](https://docs.qiime2.org/2023.7/tutorials/moving-pictures/)* de QIIME2.



## Manos a la obra
## Preparar espacio de trabajo
### 0.0 Instalar QIIME2

QIIME2 se puede correr en un ambiente **Conda**, las instrucciones de instalación para cada sistema operativo las puedes encontrar [aquí.](https://docs.qiime2.org/2023.7/install/native/#install-qiime-2-within-a-conda-environment)

Para el servidor del ICMyL en el que trabajamos, se instaló con las siguientes lineas:

```bash
# wget https://data.qiime2.org/distro/core/qiime2-2022.11-py38-linux-conda.yml
# conda env create -n qiime2-2022.11 --file qiime2-2022.11-py38-linux-conda.yml
```

 ### 0.1 Entra al servidor

```bash
ssh -X -Y USUARIO@132.248.15.30 -p NÚMERO_PUERTO -o ServerAliveInterval=60
```

- [ ] Dirígete al espacio en `/botete/` en el que siempre estarás trabajando. Este espacio sólo es para este servidor, en tu computadora u otros servidores la ruta será diferente.

```bash
cd /botete/USUARIO
```

#### 0.1.1 Inicia conda. 
**NOTA:** Iniciar conda sólo se hace una vez.

```bash
/opt/anaconda3/bin/conda init bash
```

- [ ] Sal del servidor
- [ ] Vuelve a entrar y entra a tu espacio en `/botete/usuario`

### 0.2 Activar el ambiente de QIIME2

**NOTA** Este paso si se hace cada vez que entres al servidor y trabajes con QIIME2

```bash
conda activate /botete/diana/.conda/envs/qiime2-2022.11
```
### 0.3 Crear directorios de trabajo
- [ ] Vamos a crear el directorio y espacio de trabajo

```bash
mkdir -p 02.Amplicones_16S_Qiime2/{data,src,results}
cd 02.Amplicones_16S_Qiime2/
```

### 0.4 Obtener archivos necesarios
- [ ] Crea una liga simbólica a los datos, copia el archivo de metadata y los scripts.

```bash
# Liga simbólica
ln -s /botete/diana/Hackeando_las_comunidades_microbianas_v1/02.Amplicones_16S_Qiime2/data/*.gz data/
# copiar el metadata
cp /botete/diana/Hackeando_las_comunidades_microbianas_v1/02.Amplicones_16S_Qiime2/data/metadata.tsv data/
# copiar los scripts
cp /botete/diana/Hackeando_las_comunidades_microbianas_v1/02.Amplicones_16S_Qiime2/src/* src/
# Copiar la base de datos
cp /botete/diana/Hackeando_las_comunidades_microbianas_v1/02.Amplicones_16S_Qiime2/data/*.qza data/

```
### 0.5 Crear el archivo manifest

Ya que copiaste los archivos necesarios, lista el contenido de tus directorio `data` , veamos que contiene el archivo `metadata.tsv`

Recordemos que Qiime2 requiere de un archivo `manifest` que contenga la ubicación e información de los archivos `fastq`. Así que ejecuta el `script 02` para crear tu archivo manifest:

```bash
bash src/02.create_manifest.sh
```

- [ ] Observa que contiene el archivo `manifest.csv`

Ahora si tenemos todos los datos de entrada para comenzar con el *pipeline*.

### 1. Importar los datos

   Observa el contenido de `03.import_data.sh` y ve a la ayuda de qiime para conocer cada uno de los *plugins* que estamos poniendo. 

   Para conocer más el tipo de datos que se pueden importar, puedes visitar [esta página.](https://docs.qiime2.org/2023.7/tutorials/importing/)

```bash
bash src/03.import_data.sh
```

- [ ] Veamos como se ven las secuencias que estamos analizando. Puedes descargar el archivo `results/01.demux.qzv` que acabas de generar o puedes descargarlo desde este repositorio y verlo en [QIIME2view](https://view.qiime2.org/).

### 2. Remover adaptadores

   Como no hemos hecho ningún preprocesamiento a los datos y sabemos que nuestras secuencias tienen adaptadores, los removeremos con `cutadapt` dentro de QIIME2.

   - [ ] Primero observa la ayuda de este paso de limpieza.

     ```bash
     qiime cutadapt trim-paired --help
     ```

   - [ ] Ahora si removamos los adaptadores, puedes modificar, agregar parámetros al script para mejorar.

   ```bash
   bash src/04.clean_adapter.sh
   ```

   Observemos el archivo `02.demux_clean_adapter.qzv` , ¿qué ocurrió con la calidad?

### 3. Eliminación de ruido y agrupamiento con Dada2

   Antes de comenzar el *denoising* , veamos la ayuda.

   ```bash
   qiime dada2 denoise-paired --i-demultiplexed-seqs --help
   ```

   Como habrás notado, es necesario tomar decisiones basadas en la calidad de nuestras lecturas para definir los valores de truncado.
   Es muy importante dener en cuenta la longitud de las lecturas y del amplicón deseado para tener una idea de la longitud del sobrelape que se obtendría. 

   
$$
(longitud lectura Fordware) + (longitud lectura Reverse) − (longitud del amplicon) − (longitud lectura Fordware − --p-trunc-len-f value) − (longitud lectura Reverse − --p-trunc-len-r value) = sobrelape
$$


   - [ ] Edita el script `src/05.denoising.sh` y modifica los valores de truncado del *denoising* y/o los que consideres que pueden mejorar los resultados.

   ```bash
   bash src/05.denoising.sh
   ```

   - [ ] **Opcional**: Si realizaste más de una versión extra a las 3 versiones propuestas, puedes obtener sus estadisticos con el siguiente script.

   ```bash
   #bash src/06.get_denoising_info.sh
   ```

   - [ ] O puedes obtener los estadísticos de la versión 4 que creaste con la siguiente línea

   ```bash
   qiime tools export --input-path results/03.denoising-stats_v4.qza --output-path results/03.denoising-stats_v4
   ```

   - [ ] Observa  los estadísticos de los resultados que obtuviste y compáralos con los de las versiones v1-v3, para ello, copia los resultados de las versiones 1 a 3 y de la nueva versión 4 que ya hiciste, a un nuevo directorio de estadísticos de las versiones de denoising.

   ```bash
   mkdir -p results/stats_versions
   cp /botete/diana/Hackeando_las_comunidades_microbianas_v1/02.Amplicones_16S_Qiime2/results/03.denoising-stats_v*/*stats_v* results/stats_versions/
   cp results/03.denoising-stats_v4/stats.tsv results/03.denoising-stats_v4/stats_v4.tsv
   ```

   - [ ] Vamos a compararlos

   ```bash
   head results/stats_versions/*.tsv
   ```

   Antes de conocer el resultado que obtuviste, al comparar las tres versiones, seleccionamos la v3 por ser con la que se recuperó un mayor número de ASVs. Así que en adelante trabajaremos con esta versión.

   

### 4. Asignación taxonómica

   Utilizaremos `sklearn` para realizar la asignación taxonómica, por lo tanto utilizaremos una base de datos preentrenada. La puedes encontrar [aquí](https://docs.qiime2.org/2022.11/data-resources/).

   Recuerda que puedes modificar el script con la versión que obtuviste o cambiando algún parámetro.

   ```bash
   bash src/07.tax_assign.sh
   ```

   

### Git

```bash
git config --global user.name "tuNombre"
git config --global user.email "correo@gmail.com
#entra al directorio de trabajo
git init
nano .gitignore
git add .gitignore
git add *
git commit -m "create repository"
git branch -M main
git remote add origin https://github.com/DianaOaxaca/02.Amplicones_16S_Qiime2.git

git push -u origin main
#nombre de usuario
#public-key
```



#### Bases de datos

Si hacemos la asignación taxonómica por `blast` o `vsearch` podemos descargar y usar directamente la base de datos desde [data-resources](https://docs.qiime2.org/2023.2/data-resources/) en QIIME2.

Para `sklearn`, es necesario reparar la base de datos de [Silva](https://www.arb-silva.de/), también se puede hacer con la [GTDB](https://data.gtdb.ecogenomic.org/) o [Greengenes](http://ftp.microbio.me/greengenes_release/2022.10/).

**Tomado de**: https://forum.qiime2.org/t/processing-filtering-and-evaluating-the-silva-database-and-other-reference-sequence-data-with-rescript/15494

```bash
#Dentro del ambiente de qiime
mamba install -c conda-forge -c bioconda -c qiime2 -c 2023.5-tested -c defaults xmltodict 'q2-types-genomics>2023.2' ncbi-datasets-pylib
pip install git+https://github.com/bokulich-lab/RESCRIPt.git

```

Obtener la base de datos

```bash
qiime rescript get-silva-data \
    --p-version '138.1' \
    --p-target 'SSURef_NR99' \
    --o-silva-sequences silva-138.1-ssu-nr99-rna-seqs.qza \
    --o-silva-taxonomy silva-138.1-ssu-nr99-tax.qza
```

Filtrar las secuencias de mala calidad: elimina secuencias que contengan 5 o más bases ambiguas y cualquier homopolímero que tenga 8 o más bases de longitud. 

```bash
qiime rescript cull-seqs --i-sequences silva-138.1-ssu-nr99-rna-seqs.qza --o-clean-sequences silva-138.1-ssu-nr99-seqs-cleaned.qza
```

Filtrar secuencias por longitud y taxonomía.

En lugar de filtrar ciegamente todas las secuencias de referencia por debajo de una determinada longitud, filtraremos diferencialmente según la taxonomía de la secuencia de referencia. La razón: si decidimos eliminar cualquier secuencia por debajo de 1000 o 1200 pb, muchas de las secuencias de referencia asociadas con Archaea (y algunas bacterias) se perderán. Esto aumentará potencialmente la retención de secuencias bacterianas o eucariotas más cortas y de menor calidad. En última instancia, provoca un sesgo indebido en la selección de la base de datos. Por lo tanto, intentaremos mitigar estos problemas filtrando diferencialmente según la longitud. Eliminaremos las secuencias de genes de ARNr que no *cumplan* con los siguientes criterios: Archaea (16S) >= 900 pb, Bacteria (16S) >= 1200 pb y cualquier Eucariota (18S) >= 1400 pb. Consulta la ayuda para obtener más información.

```bash
qiime rescript filter-seqs-length-by-taxon --i-sequences silva-138.1-ssu-nr99-seqs-cleaned.qza --i-taxonomy silva-138.1-ssu-nr99-tax.qza \
    --p-labels Archaea Bacteria Eukaryota \
    --p-min-lens 900 1200 1400 \
    --o-filtered-seqs silva-138.1-ssu-nr99-seqs-filt.qza \
    --o-discarded-seqs silva-138.1-ssu-nr99-seqs-discard.qza
```

Agrupar las secuencias de referencia antes de construir su clasificador, puede hacerlo agregando el `--p-perc-identity`parámetro. Aunque no siempre es necesario, esto es útil por un par de razones prácticas, por ejemplo, para ahorrar memoria y/o requisitos de almacenamiento. En el siguiente ejemplo, construimos una base de datos de secuencias de referencia del 97% con una taxonomía de consenso calculada 'lca'. 

```bash
qiime rescript dereplicate \
    --i-sequences silva-138.1-ssu-nr99-seqs-filt.qza \
    --i-taxa silva-138.1-ssu-nr99-tax.qza \
    --p-perc-identity 0.97 \
    --p-mode 'lca' \
    --o-dereplicated-sequences silva-138.1-ssu-c97-seqs-derep-lca.qza \
    --o-dereplicated-taxa silva-138.1-ssu-c97-tax-derep-lca.qza
```

#### 


#### Referencias

Bolyen, E., Rideout, J.R., Dillon, M.R. et al. Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2. Nat Biotechnol 37, 852–857 (2019). https://doi.org/10.1038/s41587-019-0209-9

Rocha-Arriaga, C., Espinal-Centeno, A., Martinez-Sanchez, S., Caballero-Pérez, J., Alcaraz, L. D., & Cruz-Ramírez, A. (2020). Deep microbial community profiling along the fermentation process of pulque, a biocultural resource of Mexico. *Microbiological Research*, *241*, 126593

