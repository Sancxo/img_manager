image_ext = [".jpg", ".jpeg", ".png", ".gif", ".bmp"]
files = File.ls!
    |> Enum.filter(&(String.ends_with?(&1, image_ext)))

number_of_files = Enum.count(files)
msg = case number_of_files do
    1 -> "file"
    _ -> "files"
end
IO.puts "Hola, muchacho ! We've found #{number_of_files} image #{msg}."

if number_of_files !== 0 do
    if !File.exists?("./img") do
        case File.mkdir("./img") do
            {:ok} -> IO.puts(~s("img" directory succefully created.))
            {:error, _} -> IO.puts(~s(Could not create "img" directory.))
        end
    else
        IO.puts(~s(There already is a "img" directory. We will use it to store your images.))
    end

    Enum.each(files, fn(filename) -> 
        case File.rename(filename, "./img/#{filename}") do
            :ok -> IO.puts(~s("#{filename}" succefully moved into "img".))
            {:error, _} -> IO.puts(~s(Could not move "#{filename}" into "img" directory.))
        end
    end)
else
    IO.puts("No images found in this directory. \nAdios !")
end