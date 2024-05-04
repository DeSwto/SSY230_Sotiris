function y_pred = idpredict(model, z, horizon)
    if strcmp(model.type, 'ARX')
        zero = max(model.na, model.nb + model.nk - 1);
        phi = uy2phi([zeros(zero, 2); z], [model.na, model.nb, model.nk]); % Generate regressor
        phi(:, 1) = []; % Remove the first column if needed
        y_pred = phi * model.theta; % Initial prediction
    elseif strcmp(model.type, 'OE')
        % Prediction for OE models does not use past output terms directly
        u = z(:,2);  % Input data
        B = model.B; % Ensure row vector
        F = model.F; % Ensure row vector
        y_pred = lsim(tf(B, F, -1), u);  % Simulate using system transfer function
    else
        error('Unknown model type');
    end

    if horizon > 1
        for h = 2:horizon
            z = [y_pred, z(:, 2)]; % Update input data with predicted outputs
            y_pred = idpredict(model, z, 1); % Recursive prediction for each step
        end
    end
end

% function y_pred = idpredict(model, z, horizon)
% 
%     zero = max(model.na, model.nb + model.nk - 1);
%     phi = uy2phi([zeros(zero, 2); z], [model.na, model.nb, model.nk]); % Generate regressor
%     phi(:, 1) = []; % Remove the first column (if needed, depending on your uy2phi implementation)
%     y_pred = phi * model.theta; % Initial prediction
% 
%     if horizon > 1
%         z = [y_pred, z(:, 2)];
%         y_pred = idpredict(model, z, horizon-1);
%     end
% end
