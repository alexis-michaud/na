Automatic phonemic transcription: full set of automatic transcriptions produced in September 2022
================================

This folder makes public a set of transcriptions produced by Séverine Guillaume and Guillaume Wisniewski. They created an acoustic model for Na by using the (hand-made) transcriptions of Na texts in the present repository (`here <https://github.com/alexis-michaud/na/tree/master/TEXT/F4>`_) as a training corpus. Then this acoustic model was used for transcribing fresh materials. 

The technology is HuggingFace Transformers - wav2vec2. Unlike the workflow described `here <https://halshs.archives-ouvertes.fr/halshs-03647315>`_, there is no word-level recognition, only character-level.
