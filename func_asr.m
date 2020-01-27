function text = func_asr(filename)
    path = fullfile(pwd, 'test.sh');
    path = strcat(path, {' '}, filename);
    [status, text] = system(path);
    text = extractAfter(text, "utterance-id1 ");
    text = extractAfter(text, "utterance-id1 ");
    text = extractAfter(text, "utterance-id1 ");
    text = extractBefore(text, "LOG");
end