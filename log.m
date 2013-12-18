%% Laplacian of Gaussian function
function outputimage = log(inputimage)

kanaal = 1;
outputimage = edge(inputimage(:,:,kanaal), 'log', 0.004);


