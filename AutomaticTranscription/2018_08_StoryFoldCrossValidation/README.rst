This folder contains a complete set of 'parallel-text' versions of the Na documents: 
the text as transcribed by the linguist, and the automatically generated transcription
(with an acoustic model which includes tone-group boundaries). 
This allows for comparison of the linguist’s transcription with the output of Persephone.

The method consists in setting aside one of the transcribed texts, training a model on the rest of the corpus, then applying that model to the extracted text. This is referred to technically as “cross-validation”.
This parallel view is intended for error analysis (to identify aspects of the tool that can be improved), but it also brings out errors in the original transcriptions.
