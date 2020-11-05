#!/bin/bash

module purge --force
export CONDA_TARGET_DIR=/p/scratch/training2005/geomar_challenge/kernel
export JUPYTER_KERNEL_NAME=GEOMAR-challenge

if [ "${1}" == "install" ]; then

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p ${CONDA_TARGET_DIR}
${CONDA_TARGET_DIR}/bin/conda env create -f environment.yml

rm Miniconda3-latest-Linux-x86_64.sh
${CONDA_TARGET_DIR}/bin/conda clean --all --yes

elif [ "${1}" == "register" ]; then

export JUPYTER_USER_KERNEL_DIR=${HOME}/.local/share/jupyter/kernels/${JUPYTER_KERNEL_NAME}
mkdir -p ${JUPYTER_USER_KERNEL_DIR}

echo '{
 "argv": [
  "'"${CONDA_TARGET_DIR}"'/conda-jupyter-kernel.sh",
  "-f",
  "{connection_file}"
 ],
 "display_name": "'"${JUPYTER_KERNEL_NAME}"'",
 "language": "python"
}' > ${JUPYTER_USER_KERNEL_DIR}/kernel.json

else

source ${CONDA_TARGET_DIR}/etc/profile.d/conda.sh
conda activate geomar-challenge-env
exec python -m ipykernel $@

fi

