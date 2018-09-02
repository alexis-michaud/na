This folder contains a working
document produced in January 2018: a parallel view of an entire text, allowing for
comparison of the linguist’s transcription with the output of \textsc{Persephone} 
(with version 3 of the acoustic model, which includes tone-group boundaries). 

The method consists in setting aside one of the transcribed texts (in this instance:
BuriedAlive2), training a model on the rest of the corpus, then applying that model
to the extracted text (this is referred to technically as “cross-validation”). 

This parallel
view is intended for error analysis (to identify aspects of the tool that can be
improved), but it also brings out errors in the original transcriptions.
