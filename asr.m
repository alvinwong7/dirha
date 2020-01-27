[status, text] = system(path);
text = extractAfter(text, "utterance-id1 ");
text = extractAfter(text, "utterance-id1 ");
text = extractAfter(text, "utterance-id1 ");
text = extractBefore(text, "LOG");