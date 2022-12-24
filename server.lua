db = dbConnect("sqlite", "data.db") 


function createDB(table_name)

   dbExec(db, 'CREATE TABLE IF NOT EXISTS '..table_name..' ( id INTEGER PRIMARY KEY AUTOINCREMENT, general TEXT)')
   dbExec(db, 'INSERT INTO '..table_name..' (general) VALUES(?)', toJSON({}))

end
--createDB("general")

function getDB(table_name, fnc)
   dbQuery(function(queryHandle) 
      local results = dbPoll(queryHandle, 0)
      local results = results[1]
      if results ~= nil then
          fnc(fromJSON(results.general))
      end
  end, db, "SELECT * FROM "..table_name.."", oyun_isim)
end

function getFrom(key, val)

   getDB("account", function(results)

      for index, value in pairs(results) do

         if value[key] == val then
            print("Found..")
            iprint(results[index])
            break
         end


      end
   end)

end

--getFrom(bakilacak_stün, aranacak değer)
getFrom("Kullanici_adi", 29039)

function addDB(...)
      local array = {...}
      local mongo = {}
      local count = 0
      for index, value in pairs(array) do
         if array[index+1+count] ~= nil then    
            mongo[array[index+count]] = array[index+1+count]
            count = count + 1
         end
      end

      getDB("account", function(results)
         table.insert(results, mongo)
         local table_name = "account"
         dbExec(db, "UPDATE "..table_name.." SET general=?", toJSON(results))
      end)
end

-- for i = 1, 100 do
--    print(i)
  --addDB("Eklenecek stün", "eklenecek değer", "Eklenecek stün", "eklenecek değer")
   addDB("Kullanici_adi", math.random(1, 100000), "Sifre", "123456", "Eposta", "drewski.js@gmail.com", "Live", "Ankara", "Yetki", "Admin")
-- end
