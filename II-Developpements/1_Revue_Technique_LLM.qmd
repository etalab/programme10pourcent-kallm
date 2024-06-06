# Guide du LLM

## PARTIE II. Développements autour des LLMs (pour les data scientists)

### 1. Revue technique de l’état de l’art LLM (Malo Jérôme)

	a. Architectures principales LLM
 
	b. Méthodes de fine-tuning  (Conrad)

	Les LLM sont des réseaux de neurones de taille importante et font l'objet d'entraînement avec des ressources colossales (*e.g*: quelques dizaines de milliers de GPUs dernier modèle pendant 3 mois pour `GPT-4`). L'entraînement permet d'apprendre un jeu de données particulier, en réglant l'ensemble des poids du modèles (*e.g*: `Mixtral 8x22B` est une architecture à 141 milliards de poids; 175 milliards pour `GPT-3`). Les LLM sont entraînés à répondre à plusieurs tâches génériques et ne sont pas forcément pertinent pour des cas d'utilisation particulier.

	Pour répondre à ce besoin, plusieurs méthodes relevant du principe de fine-tuning sont possibles. Le fine-tuning consiste à reprendre un modèle déjà entraîné et à l'adapter sur un jeu de données particulier sur une ou plusieurs tâches spécifiques. En général, il s'agit de modifier une partie ou l'ensemble des poids pour que le modèle soit plus précis pour les tâches voulues. Le fine-tuning garde en grande partie les bénéfices de l'entraînement initial, *i.e* les connaissances antérieurs déjà apprises. Repartir d'un modèle déjà entraîné pourra réduire le temps d'entraînement requis pour le fine-tuning, en fonction de la similarité entre la nouvelle tâche souhaitée et son jeu de données et les entraînements précédents.
 
	Pour des petits modèles de langages, il est possible de ré-entraîner en modifiant l'ensemble des poids. Pour des modèles plus grands, modifier l'ensemble des poids peut s'avérer couteux en temps et en GPUs. Plusieurs approches permettent de ré-entraîner à moindre coût :
	* réentrainer seulement un sous-ensemble de poids
	* modifier la tête de modélisation de la langue (`lm_head`) pour certains modèles, soit en réentrainant depuis les poids entraînés, soit en réinitialisant ces poids.
	* garder l'intégralité du modèle et rajouter des poids à entraîner puis utiliser l'approximation de bas rang avec `LORA` (`Low-Rank Adaptation`) pour l'entraînement et l'inférence.
	* utiliser des versions quantisées, i.e. des modèles où les poids ont été tronqués à une précision inférieure (possibilité de combiner avec la technique précédente, sous le nom de qLORA).

	Entraînement avec qLORA en pratique :

	En plus de la librairie `transformers` et `datasets`, les librairies `peft`, `bitsandbytes` et `trl` permettent de simplifier l'entraînement avec qLORA

	(inspiré du [notebook suivant](https://www.kaggle.com/code/kingabzpro/mistral-7b-instruct-4bit-qlora-fine-tuning) )

	```python
%%capture
%pip install -U bitsandbytes
%pip install -U transformers
%pip install -U peft
%pip install -U trl
%pip install -U sentencepiece
%pip install -U protobuf

from transformers import AutoModelForCausalLM, AutoTokenizer,TrainingArguments
from peft import LoraConfig, prepare_model_for_kbit_training, get_peft_model
from datasets import load_dataset
import torch
from trl import SFTTrainer

base_model = "teknium/OpenHermes-2.5-Mistral-7B"
new_model = "Mistral-7b-instruct-teletravail"

path_to_training_file="Dataset_public_accords_teletravail_Dares_train.parquet"
path_to_test_file="Dataset_public_accords_teletravail_Dares_test.parquet"


dataset=load_dataset("parquet", data_files={'train': path_to_training_file, 'test': path_to_test_file})

bnb_config = BitsAndBytesConfig(
    load_in_4bit= True,
    bnb_4bit_quant_type= "nf4",
    bnb_4bit_compute_dtype= torch.bfloat16,
    bnb_4bit_use_double_quant= False,
)

model = AutoModelForCausalLM.from_pretrained(
        base_model,
        quantization_config=bnb_config,
        torch_dtype=torch.bfloat16,
        device_map="auto",
        trust_remote_code=True,
)
model.config.use_cache = False # silence the warnings. Please re-enable for inference!
model.config.pretraining_tp = 1
model.gradient_checkpointing_enable()

# Load tokenizer
tokenizer = AutoTokenizer.from_pretrained(base_model, trust_remote_code=True)
tokenizer.padding_side = 'right'
tokenizer.pad_token = tokenizer.eos_token
tokenizer.add_eos_token = True
tokenizer.add_bos_token, tokenizer.add_eos_token


model = prepare_model_for_kbit_training(model)
peft_config = LoraConfig(
    lora_alpha=16,
    lora_dropout=0.1,
    r=64,
    bias="none",
    task_type="CAUSAL_LM",
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj","gate_proj"]
)
model = get_peft_model(model, peft_config)

training_arguments = TrainingArguments(
    output_dir="./results",
    num_train_epochs=1,
    per_device_train_batch_size=4,
    gradient_accumulation_steps=1,
    optim="paged_adamw_32bit",
    save_steps=25,
    logging_steps=25,
    learning_rate=2e-4,
    weight_decay=0.001,
    fp16=False,
    bf16=False,
    max_grad_norm=0.3,
    max_steps=-1,
    warmup_ratio=0.03,
    group_by_length=True,
    lr_scheduler_type="constant",
)

trainer = SFTTrainer(
    model=model,
    train_dataset=dataset["train"],
    peft_config=peft_config,
    max_seq_length= None,
    dataset_text_field="text",
    tokenizer=tokenizer,
    args=training_arguments,
    packing= False,
)

trainer.train()

trainer.model.save_pretrained(new_model)

	```


	c. Prompt engineer (lien vers prompt guide)
 
	d. Quoi faire quand ? (arbre de décision)
