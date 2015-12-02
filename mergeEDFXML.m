function mergeEDFXML(edffile,xmlfile)
% opens an edf file and its correasponding xml file containing annotations
% and returns a Matlab struct file contaning information from both
% edffile and xmlfile are strings containing the names of the files you want to merge
edfObj = BlockEdfLoadClass(edffile);
edfObj.numCompToLoad = 3;      % Don't return object
edfObj = edfObj.blockEdfLoad;  % Load data
labels=edfObj.signal_labels;
samplerate=edfObj.sample_rate;
physdim=edfObj.physical_dimension;
startdate=edfObj.edf.header.recording_startdate;
starttime=edfObj.edf.header.recording_starttime;
d=edfObj.edf.signalCell;
signal=struct;
for jj=1:length(labels)
    lab=labels{jj};
    lab=regexprep(lab,[{' '},{'-'},{'+'}],'');
    if ~isletter(lab(1))
        lab=['s' lab];
    end
    s.data=d{jj};
    s.fs=samplerate(jj);
    s.units=physdim{jj};
    s.startdate=startdate;
    s.starttime=starttime;
    signal=setfield(signal,lab,s);
end
a=xml2struct(xmlfile);
signal=setfield(signal,'PSGAnnotation',a.PSGAnnotation);
save (edffile(1:end-4),'signal')