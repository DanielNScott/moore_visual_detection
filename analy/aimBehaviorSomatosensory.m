% find the timing in ms of each stimulus
[stimOnSamps,stimOnVect]=getStateSamps(bData.teensyStates,2,1);
[catchOnSamps,catchOnVect]=getStateSamps(bData.teensyStates,3,1);
stimSamps = [stimOnSamps, catchOnSamps];
stimSamps = sort(stimSamps);
% later code refers to the stimSamps as whiskerSample, so it is assigned
% here as whiskerSample, even though its vision contrast
whiskerSample = stimSamps;

% find the timing in ms of each reward and lick
[rewardOnSamps, rewardOnVect] = getStateSamps(bData.teensyStates,4,1);
[licks, licksVect] = getStateSamps(bData.thresholdedLicks, 1, 1);

lickWindow = 1500;

% loop over the first one hundred trials and extract hit/miss information
    for n = 1:numel(whiskerSample)-1
        % for touch
        bData.c1_amp = bData.c1_amp(1:numel(whiskerSample)-1)
        parsed.amplitude(n)=bData.c1_amp(n);
        % for vision
        %parsed.amplitude(n)=bData.contrast(n);
        tempLick = find(bData.thresholdedLicks(stimSamps(n):stimSamps(n)+lickWindow)==1);
        tempRun = find(bData.binaryVelocity(stimSamps(n):stimSamps(n)+ lickWindow) == 1);

        % check to see if the animal licked in the window
        if numel(tempLick)>0
            % it licked
            parsed.lick(n) = 1;
            parsed.lickLatency(n) = tempLick(1) - stimSamps(n);
            parsed.lickCount(n) = numel(tempLick);
            if parsed.amplitude(n)>0
                parsed.response_hits(n) = 1;
                parsed.response_miss(n) = 0;
                parsed.response_fa(n) = NaN;
                parsed.response_cr(n) = NaN;
            elseif parsed.amplitude(n) == 0
                parsed.response_fa(n) = 1;
                parsed.response_cr(n) = 0;
                parsed.response_hits(n) = NaN;
                parsed.response_miss(n) = NaN;
            end
        elseif numel(tempLick)==0
            parsed.lick(n) = 0;
            parsed.lickLatency(n) = NaN;
            parsed.lickCount(n) = 0;
            if parsed.amplitude(n)>0
                parsed.response_hits(n) = 0;
                parsed.response_miss(n) = 1;
                parsed.response_fa(n) = NaN;
                parsed.response_cr(n) = NaN;
            elseif parsed.amplitude(n) == 0
                parsed.response_fa(n) = 0;
                parsed.response_cr(n) = 1;
                parsed.response_hits(n) = NaN;
                parsed.response_miss(n) = NaN;
            end
        end
        
        % extract whether or not the mouse ran during the report window
        if numel(tempRun) > 0
            parsed.run(n) = 1;
            tempVel = bData.velocity(stimSamps(n):stimSamps(n)+ lickWindow);
            parsed.vel(n) = nanmean(abs(tempVel));
        else
            parsed.run(n) = 0;
            parsed.vel(n) = 0;
        end
        
    end
    
    
    
% get perent correct each day

maxTrials = find(bData.c1_amp == 4000);
threshTrials = find(ismember(bData.c1_amp, [100, 150 200 500]));

maxVect = parsed.response_hits(maxTrials);
threshVect = parsed.response_hits(threshTrials);clc

maxPerc = sum(maxVect)./numel(maxVect);
threshPerc = sum(threshVect)./numel(threshVect);
    
    
smtWin = 30;

parsed.hitRate = nPointMean(parsed.response_hits(maxTrials), smtWin)';


parsed.hitRate = nPointMean(parsed.response_hits, smtWin)';
parsed.faRate = nPointMean(parsed.response_fa, smtWin)';
parsed.dPrime = norminv(parsed.hitRate) - norminv(parsed.faRate);
parsed.criterion = 0.5*(norminv(parsed.hitRate) + norminv(parsed.faRate));




figure
subplot(3,1,1)
plot(parsed.hitRate,'k-')
hold all
plot(parsed.faRate,'b-');
grid on

legend('Hit', 'FA')
xlabel('Trial Number');
title('Hit Rate and False Alarm Rate');
ylabel('p(H) and p(FA)')
ylim([0,1]);

subplot(3,1,2)

%d' plot
plot(parsed.dPrime,'k-')


xlabel('Trial Number');
title('D Prime')
legend('d-prime')
ylabel('d Prime')
ylim([-0.5,3])
grid on


subplot(3,1,3)

%criterion plot
plot(parsed.criterion,'k-')


xlabel('Trial Number');
title('Criterion')
legend('Criterion')
ylabel('Criterion')
ylim([-1,2])
grid on


amp0 = find(bData.c1_amp == 0);
amp1 = find(bData.c1_amp == 50);
amp2 = find(bData.c1_amp == 100);
amp3 = find(bData.c1_amp == 150);
amp4 = find(bData.c1_amp == 200);
amp5 = find(bData.c1_amp == 500);
amp6 = find(bData.c1_amp == 1000);
amp7 = find(bData.c1_amp == 2000);
ampMax = find(bData.c1_amp == 4000);

amp0Vect = parsed.response_fa(amp0);
amp1Vect = parsed.response_hits(amp1);
amp2Vect = parsed.response_hits(amp2);
amp3Vect = parsed.response_hits(amp3);
amp4Vect = parsed.response_hits(amp4);
amp5Vect = parsed.response_hits(amp5);
amp6Vect = parsed.response_hits(amp6);
amp7Vect = parsed.response_hits(amp7);
ampMaxVect = parsed.response_hits(ampMax);

hitAmp0 = sum(amp0Vect)./numel(amp0Vect);
hitAmp1 = sum(amp1Vect)./numel(amp1Vect);
hitAmp2 = sum(amp2Vect)./numel(amp2Vect);
hitAmp3 = sum(amp3Vect)./numel(amp3Vect);
hitAmp4 = sum(amp4Vect)./numel(amp4Vect);
hitAmp5 = sum(amp5Vect)./numel(amp5Vect);
hitAmp6 = sum(amp6Vect)./numel(amp6Vect);
hitAmp7 = sum(amp7Vect)./numel(amp7Vect);
hitAmpMax = sum(ampMaxVect)./numel(ampMaxVect);


hitContrastMatrix = [ hitAmp0 hitAmp1 hitAmp2 hitAmp3 hitAmp4 hitAmp5 hitAmp6 hitAmp7 hitAmpMax ];

figure
plot(hitContrastMatrix)
title('Psychometric Function')
xlabel('Contrast Level')
ylabel('P(Hit)')
