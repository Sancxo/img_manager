defmodule ImgManager do
    def start() do
        path = IO.gets(~s[Enter the path of the folder you want to manage : (type "-q" to quit the tool)\n])
            |> String.trim

        if path === "-q" do
           quit()
        else
            create_folder(path)
        end
    end

    def quit do
        quit? = IO.gets("Do you really want to quit this tool ? (Y/N) ")
            |> String.trim()

        case quit? do
            "Y" ->
                IO.puts("\nGoodbye mate !")
            "N" -> 
                start()
            _ -> 
                IO.puts("\nInvalid command, retry.\n")
                quit()
        end
    end

    def create_folder(path) do
        if File.exists?(path) and File.dir?(path) do
            folder = IO.gets(~s[Name the folder that will be created to store your images : (type "-r" to go back to previous step)\n])
                |> String.trim

            if folder === "-r" do
                start()
            else
                File.cd(path)

                if !File.exists?(folder) do 
                    File.mkdir(folder)
                    IO.puts(~s[\nFolder "#{folder}" succefully created !\n])
                else
                    IO.puts(~s[\nFolder "#{folder}" already exists, we will transfer your images into it.\n])
                end
                
                parse_imgs(path, folder)
            end
        else
            IO.puts(~s[The path "#{path}" doesn't exists on your computer.\n])
            start()
        end
    end

    def parse_imgs(path, folder) do
        files = File.ls()
            |> Kernel.elem(1)

        confirm(path, folder, files)
    end

    def confirm(path, folder, files) do
        Enum.any?(files, fn file -> 
            if String.ends_with?(file, [".jpg", ".png", ".gif", ".bmp"]) do
                confirm = IO.gets(~s[There is images in "#{path}", do you want to move them in "#{folder}"" ? (Y/N) ])
                    |> String.trim

                process(path, folder, files, confirm)
            end
        end)
    end

    def process(path, folder, files, confirm) do
        case confirm do
            "Y" ->
                Enum.each(files, fn file -> 
                    if String.ends_with?(file, [".jpg", ".png", ".gif", ".bmp"]) do
                        File.cp(file, "./#{folder}/" <> file)
                        File.rm(file)
                        IO.puts(~s{\n"#{file}" copied to #{folder}.\n})
                    end
                end)
                IO.puts(~s[Image files succefully moved to "#{folder}" folder !\n])
                start()

            "N" -> 
                File.rmdir(folder)
                IO.puts(~s[\n"#{folder}" removed from #{path}])
                create_folder(path)

            _ -> 
                IO.puts("\nInvalid command, retry.\n")
                parse_imgs(folder, path)

        end
    end
end