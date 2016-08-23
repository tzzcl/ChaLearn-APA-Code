-- NJU LAMDA
-- Video Classification Contest
-- Make predictions based on the trained model.
-- Author: Hao Zhang
-- Date: 2016.06.14
-- File: read_csv.lua

require('nn')
require('cunn')
require('cutorch')

m_tot = 1000
m_frame = 3059
n = 26
K = 5

torch.setdefaulttensortype('torch.CudaTensor')
-- Load X to a tensor.
function load_csv(file)
    local X = torch.Tensor(m_frame, n)
    local i = 0 -- Which row.
    for line in file:lines('*l') do
        i = i + 1 
        local l = line:split(',')
        for j, val in ipairs(l) do
            X[i][j] = val 
        end 
    end
    return X
end

-- Load the model.
model = torch.load('model.bin')
stat = torch.load('stat.bin')

-- Read each train csv file accroding to the label csv file.
y_read = io.open('./data/y_pred.csv', 'r')
y_write = assert(io.open('y_test.csv', 'w'))

-- Write header line.
header_line = y_read:read()  
y_write:write(header_line)

X = torch.Tensor(1, m_frame, n)

i = 0
for y_line in y_read:lines('*l') do  -- i = 1 to m_tot.
    i = i + 1
    local l = y_line:split(',')

    -- File name
    local val = l[1]
    print(val)
    y_write:write(val)

    -- Read X line.
    val = string.sub(l[1], 1, -4)..'csv'
    local file_name = './data/val_mfcc/'..val
    X_file = io.open(file_name, 'r')    
    X[{1, {}, {}}] = load_csv(X_file)
    X_file:close()
    X:csub(stat.mean)
    X:div(stat.std)

    -- Forward pass of the model.
    local S = model:forward(X)
    for j = 1, 5 do
        y_write:write(',')
        y_write:write(S[1][j])
    end
    y_write:write('\n')
end         

y_read:close()
y_write:close()
