sudo apt update >/dev/null 2>/dev/null && sudo apt install --yes lshw >/dev/null 2>/dev/null
curl -fsSL https://ollama.com/install.sh | sh
pip install -r  requirements.txt
curl https://minio.lab.sspcloud.fr/cthiounn2/Accords/10p_accords_publics_et_thematiques_240815_sample_of_1000.parquet -o 10p_accords_publics_et_thematiques_240815_sample_of_1000.parquet
ollama serve&