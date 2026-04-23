-- Configuration macro's for selecting which backends to build. 
-- By default, all backends are enabled.
NVRHI_WITH_VALIDATION = NVRHI_WITH_VALIDATION == nil and true or NVRHI_WITH_VALIDATION
NVRHI_WITH_VULKAN = NVRHI_WITH_VULKAN == nil and true or NVRHI_WITH_VULKAN
NVRHI_WITH_DX12 = NVRHI_WITH_DX12 == nil and true or NVRHI_WITH_DX12
NVRHI_WITH_DX11 = NVRHI_WITH_DX11 == nil and true or NVRHI_WITH_DX11

project "NVRHI"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    staticruntime "off"

    flags { "MultiProcessorCompile" }
    buildoptions { "/utf-8" }

    targetdir ("%{wks.location}/bin/" .. outputdir .. "/%{prj.name}")
    objdir ("%{wks.location}/bin-int/" .. outputdir .. "/%{prj.name}")

    files 
    {
        "include/nvrhi/nvrhi.h",
        "include/nvrhi/nvrhiHLSL.h",
        "include/nvrhi/utils.h",
        "include/nvrhi/common/**.h",
        "src/common/**.h",
        "src/common/**.cpp"
    }

    if NVRHI_WITH_VALIDATION then
        files 
        {
            "include/nvrhi/validation.h",
            "src/validation/**.h",
            "src/validation/**.cpp"
        }
    end

    removefiles 
    {
        "src/common/dxgi-format.*"
    }

    includedirs 
    {
        "include"
    }

    defines 
    {
        "NVRHI_WITH_AFTERMATH=0"
    }

    filter "system:windows"
        systemversion "latest"
        files { "tools/nvrhi.natvis" }

    filter "configurations:Debug"
        runtime "Debug"
        symbols "On"

    filter "configurations:Release"
        runtime "Release"
        optimize "On"

    filter "configurations:Dist"
        runtime "Release"
        optimize "On"

if NVRHI_WITH_DX12 then
    project "NVRHI_D3D12"
        kind "StaticLib"
        language "C++"
        cppdialect "C++17"
        staticruntime "off"

        flags { "MultiProcessorCompile" }
        buildoptions { "/utf-8" }

        targetdir ("%{wks.location}/bin/" .. outputdir .. "/%{prj.name}")
        objdir ("%{wks.location}/bin-int/" .. outputdir .. "/%{prj.name}")

        files 
        {
            "include/nvrhi/d3d12.h",
            "src/common/dxgi-format.*",
            "src/common/versioning.h",
            "src/d3d12/**.h",
            "src/d3d12/**.cpp"
        }

        includedirs 
        {
            "include",
            "thirdparty/DirectX-Headers/include"
        }

        links 
        {
            "d3d12",
            "dxgi",
            "dxguid"
        }

        defines 
        {
            "NVRHI_WITH_AFTERMATH=0",
            "NVRHI_D3D12_WITH_NVAPI=0"
        }

        filter "system:windows"
            systemversion "latest"

        filter "system:not windows"
            includedirs { "thirdparty/DirectX-Headers/include/wsl/stubs" }
            kind "None"

        filter "configurations:Debug"
            runtime "Debug"
            symbols "On"

        filter "configurations:Release"
            runtime "Release"
            optimize "On"

        filter "configurations:Dist"
            runtime "Release"
            optimize "On"
end

if NVRHI_WITH_DX11 then
    project "NVRHI_D3D11"
        kind "StaticLib"
        language "C++"
        cppdialect "C++17"
        staticruntime "off"

        flags { "MultiProcessorCompile" }
        buildoptions { "/utf-8" }

        targetdir ("%{wks.location}/bin/" .. outputdir .. "/%{prj.name}")
        objdir ("%{wks.location}/bin-int/" .. outputdir .. "/%{prj.name}")

        files 
        {
            "include/nvrhi/d3d11.h",
            "src/common/dxgi-format.*",
            "src/d3d11/**.h",
            "src/d3d11/**.cpp"
        }

        includedirs 
        {
            "include"
        }

        links 
        {
            "d3d11",
            "dxguid"
        }

        defines 
        {
            "NVRHI_WITH_AFTERMATH=0",
            "NVRHI_D3D11_WITH_NVAPI=0"
        }

        filter "system:windows"
            systemversion "latest"

        filter "system:not windows"
            kind "None"

        filter "configurations:Debug"
            runtime "Debug"
            symbols "On"

        filter "configurations:Release"
            runtime "Release"
            optimize "On"

        filter "configurations:Dist"
            runtime "Release"
            optimize "On"
end

if NVRHI_WITH_VULKAN then
    project "NVRHI_VULKAN"
        kind "StaticLib"
        language "C++"
        cppdialect "C++17"
        staticruntime "off"

        flags { "MultiProcessorCompile" }
        buildoptions { "/utf-8" }

        targetdir ("%{wks.location}/bin/" .. outputdir .. "/%{prj.name}")
        objdir ("%{wks.location}/bin-int/" .. outputdir .. "/%{prj.name}")

        files 
        {
            "include/nvrhi/vulkan.h",
            "src/common/versioning.h",
            "src/vulkan/**.h",
            "src/vulkan/**.cpp"
        }

        includedirs 
        {
            "include",
            "thirdparty/Vulkan-Headers/include"
        }

        defines 
        {
            "NVRHI_WITH_AFTERMATH=0",
            "VULKAN_HPP_DISPATCH_LOADER_DYNAMIC=1"
        }

        filter "system:windows"
            systemversion "latest"
            defines 
            {
                "VK_USE_PLATFORM_WIN32_KHR",
                "NOMINMAX"
            }

        filter "system:linux"
            defines { "VK_USE_PLATFORM_XLIB_KHR" }

        filter "system:macosx"
            defines { "VK_USE_PLATFORM_MACOS_MVK" }

        filter "configurations:Debug"
            runtime "Debug"
            symbols "On"

        filter "configurations:Release"
            runtime "Release"
            optimize "On"

        filter "configurations:Dist"
            runtime "Release"
            optimize "On"
end