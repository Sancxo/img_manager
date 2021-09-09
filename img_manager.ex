defmodule ImgManager do
    def start() do
        path = IO.gets(~s[Enter the path of the folder you want to manage : (type "-q" to quit the tool)\n])
            |> String.trim

        if path == "-q" do
           "Goodbye !"
        else
            if File.exists?(path) and File.dir?(path) do
                folder = IO.gets("Name the folder we will create to store your images : ")
                    |> String.trim


                File.cd(path)

                if !File.exists?(folder), do: File.mkdir(folder)
                
                File.ls()
                |> Kernel.elem(1)
                |> Enum.each(fn x -> 
                    if String.ends_with?(x, [".jpg", ".png", ".gif", ".bmp"]) do
                        File.cp(x, "./#{folder}/" <> x)
                        File.rm(x)
                    end
                end)
                
                IO.puts(~s[Image files succefully moved to "#{folder}" folder !\n])
            else
                IO.puts(~s[The path "#{path}" doesn't exists on your computer.\n])
            end

            start()
        end
    end
end