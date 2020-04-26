local fio = require('fio')
local csv= require('csv')
local csv_opts = {skip_head_lines = 1, delimiter = ',' }
local http_client = require('http.client').new()

function download(start_time)
    local start_date = os.date('%m-%d-%Y', start_time)
    local file_path = 'tmp/' .. start_date .. '.csv'
    if fio.path.is_file(file_path) then
        return false, file_path
    end

    local download_uri_pattern = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/current_date.csv'
    local download_uri = download_uri_pattern:gsub('current_date', start_date)
    local csv_file_resp = http_client:request('GET', download_uri)
    if csv_file_resp.status == 404 then
        return false, file_path
    end

    if not csv_file_resp.body then
        return false, file_path
    end

    local csv_file = fio.open(file_path, { 'O_RDWR', 'O_TRUNC', 'O_CREAT' }, tonumber('0755', 8))
    csv_file:write(csv_file_resp.body)
    csv_file:close()

    return true, file_path
end

--[[All stats files startes from 20.01.2020]]
local end_point = os.time()
local start_point = os.time({year = '2020', month = '01', day = '20'})

--[[Tarantool Connect Service]]
box.cfg{
    listen='covid19User:imhere@localhost:3301',
    read_only=true,
}
covid19_space = box.space.covid19_space
if covid19_space then
    --[[Loop for between start to current dates]]
    print('Started')
    while true do
        if start_point > end_point then
            print('Finished')
            return true
        end

        local is_success, file_path = download(start_point)
        if is_success then
            print(file_path .. ' downloaded')
            local csv_file = fio.open(file_path, {'O_RDONLY'})
            if not csv_file then
                print(file_path .. ' not reading')
            else
                for row, column in csv.iterate(csv_file, csv_opts) do
                    --[[Province/State,Country/Region,Last Update,Confirmed,Deaths,Recovered]]
                    covid19_space:insert({
                        null, --[[Primary key]]
                        start_point, --[[Unix Time]]
                        column[1], --[[Province/State]]
                        column[2], --[[Country/Region]]
                        column[3], --[[Last Update]]
                        column[4], --[[Confirmed]]
                        column[5], --[[Deaths]]
                        column[6], --[[Recovered]]
                    })
                end
                csv_file:close()
            end
        else
            print(file_path .. ' not downloaded')
        end

        start_point = start_point + 3600*24
    end
else
    print()
end

os.exit()