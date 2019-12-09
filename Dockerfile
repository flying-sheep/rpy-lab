FROM jupyter/r-notebook:7a0c7325e470

ENV JUPYTER_ENABLE_LAB=yes

# Install R packages available on conda
RUN conda config --add channels bioconda
RUN conda install --quiet --yes \
	'r-irkernel=1.1*' \
	'r-rcppeigen=0.3*' \
	'r-rcpphnsw=0.2*' \
	'r-rspectra=0.15*' \
	'r-irlba=2.3*' \
	'r-cairo=1.5' \
	'r-ggthemes=4.2*' \
	'r-vim=4.8*' \
	'r-proxy=0.4*' \
	'r-smoother=1.1*' \
	'r-scatterplot3d=0.3*' \
	'bioconductor-pcamethods=1.78*' \
	'bioconductor-singlecellexperiment=1.8*' \
	&& \
	conda clean --all -f -y && \
	fix-permissions $CONDA_DIR

# Install R packages not available on conda
RUN ln -sT libopenblasp-r0.3.7.so '/opt/conda/lib/libRlapack.so'
RUN R --slave -e 'install.packages(c("ggplot.multistats", "knn.covertree"), repos = "https://cloud.r-project.org/")'

# Install newest destiny
RUN R --slave -e 'devtools::install_github("theislab/destiny", dep = FALSE)'

# Install Python stuff
RUN conda install --quiet --yes \
	'scanpy=1.4*' \
	'rpy2=3.1*' \
	'anndata2ri=1.0*' \
	'ipywidgets=7.5*' \
	&& \
	conda clean --all -f -y && \
	fix-permissions $CONDA_DIR

# Vital Jupyter extensions
RUN jupyter labextension install \
	'@jupyter-widgets/jupyterlab-manager' \
	'jupyterlab-plotly' 'plotlywidget'
