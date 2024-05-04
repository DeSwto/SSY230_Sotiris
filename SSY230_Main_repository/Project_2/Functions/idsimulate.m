function y_sim = idsimulate(model, u)
    if strcmp(model.type, 'ARX')
        transfer = id2tf(model);
        num_states = max(model.na, model.nb-1 + model.nk);
    elseif strcmp(model.type, 'OE')
        transfer = tf(model.B, model.F, -1);  % Direct use of B/F for OE model
        num_states = max(length(model.B), length(model.F) - 1);
    else
        error('Unknown model type');
    end

    t = (0:length(u)-1)';  % time vector for unit time steps
    

    x0 = zeros(num_states, 1);

    % Simulate the model response
    y_sim = lsim(ss(transfer), u, t, x0);
end

% function y_sim = idsimulate(model, u)
%     % Convert ARX model to transfer function
%     transfer = id2tf(model);
% 
% 
%     t = (0:length(u)-1)';  % time vector for unit time steps    
% 
%     num_states = max(model.na, model.nb-1 + model.nk);
% 
%     x0 = zeros(num_states, 1);
% 
%     % Simulate the model response
%     y_sim = lsim(ss(transfer), u, t,x0);
% end