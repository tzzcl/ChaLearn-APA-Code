-- NJU LAMDA
-- Video Classification Contest
-- Read all training csv files into a gaint tensor, and labels file to a tensor.
-- Author: Hao Zhang
-- Date: 2016.06.14
-- File: train2torch.lua

m_tot = 6000
m_frame = 3059
n = 26
K = 5

torch.setdefaulttensortype('torch.FloatTensor')

-- Build the tensor.
data = torch.Tensor(m_tot, m_frame, n)
labels = torch.Tensor(m_tot, K)

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

-- Read each train csv file accroding to the label csv file.
y_file = io.open('y_train.csv', 'r')
_ = y_file:read()  -- Throw header line.

i = 0
for y_line in y_file:lines('*l') do  -- i = 1 to m_tot.
    i = i + 1
    local l = y_line:split(',')
    for j, val in ipairs(l) do  -- j = 1 to 6.
        if j == 1 then  -- val is the file name.
            val = string.sub(val, 1, -4)..'csv'
            print(val)
            file_name = 'train_logfbank/'..val
            X_file = io.open(file_name, 'r')
            data[{i, {}, {}}] = load_csv(X_file)
            X_file:close()
        else
            labels[i][j - 1] = val
        end
    end
end
y_file:close()

torch.save('data_logfbank.th', data)
torch.save('labels_logfbank.th', labels)
