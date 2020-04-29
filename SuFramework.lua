local SuFramework = {
    version = "3";
    link = "https://raw.githubusercontent.com/superyor/SuFramework/master/SuFramework.lua";
    versionLink = "https://raw.githubusercontent.com/superyor/SuFramework/master/version.txt";

    mainGuiObjects = {};
    menuCreated = false;
    varnamePrefix = "",
    categoryNames = {},
    featureNames = {},
    categoryCount = 0;
    featureCount = 0;
    currentColumn = 0;
    currentY = 0;
    categories = {};
    lastCategorySelection = 0;
}

function SuFramework.createMenu(varnamePrefix, reference, tabName)
    if not varnamePrefix or not reference or not tabName then
        return false;
    end

    SuFramework.mainGuiObjects.tab = gui.Tab(reference, varnamePrefix:lower() .. ".tab", tabName)
    SuFramework.mainGuiObjects.selectorGroup = gui.Groupbox(SuFramework.mainGuiObjects.tab, "Selector", 16, 16, 600, 64)
    SuFramework.mainGuiObjects.categorySelector = gui.Combobox(SuFramework.mainGuiObjects.selectorGroup, "selector.category", "Category", "")
    SuFramework.mainGuiObjects.featureSelector = gui.Combobox(SuFramework.mainGuiObjects.selectorGroup, "selector.feature", "Feature", "")
    SuFramework.mainGuiObjects.configureGroup = gui.Groupbox(SuFramework.mainGuiObjects.tab, "Configure", 16, 64+64, 600, 64)
    SuFramework.mainGuiObjects.categorySelector:SetWidth(300-16-4)
    SuFramework.mainGuiObjects.featureSelector:SetPosX(300-8)
    SuFramework.mainGuiObjects.featureSelector:SetPosY(0)
    SuFramework.mainGuiObjects.featureSelector:SetWidth(300-16-4)
    SuFramework.varnamePrefix = varnamePrefix;
    SuFramework.menuCreated = true;

    return true;
end

function SuFramework.addCategory(categoryName)

    if SuFramework.menuCreated == false then
        return false;
    end

    table.insert(SuFramework.categoryNames, categoryName)
    SuFramework.mainGuiObjects.categorySelector:SetOptions(unpack(SuFramework.categoryNames))
    SuFramework.categoryCount = SuFramework.categoryCount + 1;
    SuFramework.featureCount = 0;
    SuFramework.categories[SuFramework.categoryCount] = {}
    return true;
end

function SuFramework.addFeature(featureName)

    if SuFramework.menuCreated == false then
        return false;
    end

    SuFramework.featureCount = SuFramework.featureCount + 1;

    local temp = SuFramework.featureNames[SuFramework.categoryCount];
    if temp == nil then
        SuFramework.featureNames[SuFramework.categoryCount] = {};
        table.insert(SuFramework.featureNames[SuFramework.categoryCount], featureName)
    else
        table.insert(SuFramework.featureNames[SuFramework.categoryCount], featureName)
    end

    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount] = {};
    SuFramework.currentColumn = 1;
    SuFramework.currentY = 0;
    return true;
end

function SuFramework.nextColumn()

    if SuFramework.currentColumn + 1 < 3 then
        SuFramework.currentColumn = SuFramework.currentColumn + 1;
        SuFramework.currentY = 0;
        return true;
    else
        return false;
    end
end

function SuFramework.addCheckbox(varname, name, defaultValue, description, customParent)

    if SuFramework.menuCreated == false then
        return false;
    end

    local catName = SuFramework.categoryNames[SuFramework.categoryCount]
    catName = catName:gsub(" ", "");
    catName = catName:lower();

    local featName = SuFramework.featureNames[SuFramework.categoryCount][SuFramework.featureCount];
    featName = featName:gsub(" ", "");
    featName = featName:lower();

    local awVarname = catName .. "." .. featName .. "." .. varname:lower();

    if customParent then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname] =
        gui.Checkbox(customParent, awVarname, name, defaultValue);
    else
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname] =
        gui.Checkbox(SuFramework.mainGuiObjects.configureGroup, awVarname, name, defaultValue);
    end

    if SuFramework.currentColumn == 2 then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosX(300-8);
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosY(SuFramework.currentY);


    if not customParent then
        if description then
            SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetDescription(description);
            SuFramework.currentY = SuFramework.currentY + 28*1.66;
        else
            SuFramework.currentY = SuFramework.currentY + 28;
        end
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetWidth(300-16-4)

    return SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname];
end

function SuFramework.addSlider(varname, name, defaultValue, min, max, stepSize, description)

    if SuFramework.menuCreated == false then
        return false;
    end

    local catName = SuFramework.categoryNames[SuFramework.categoryCount]
    catName = catName:gsub(" ", "");
    catName = catName:lower();

    local featName = SuFramework.featureNames[SuFramework.categoryCount][SuFramework.featureCount];
    featName = featName:gsub(" ", "");
    featName = featName:lower();

    local awVarname = catName .. "." .. featName .. "." .. varname:lower();
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname] =
    gui.Slider(SuFramework.mainGuiObjects.configureGroup, awVarname, name, defaultValue, min, max, stepSize)

    if SuFramework.currentColumn == 2 then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosX(300-8);
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosY(SuFramework.currentY);

    if description then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetDescription(description);
        SuFramework.currentY = SuFramework.currentY + 48*1.4;
    else
        SuFramework.currentY = SuFramework.currentY + 48;
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetWidth(300-16-4)

    return SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname];
end

function SuFramework.addCombobox(varname, name, optionsTable, description)

    if SuFramework.menuCreated == false then
        return false;
    end

    local catName = SuFramework.categoryNames[SuFramework.categoryCount]
    catName = catName:gsub(" ", "");
    catName = catName:lower();

    local featName = SuFramework.featureNames[SuFramework.categoryCount][SuFramework.featureCount];
    featName = featName:gsub(" ", "");
    featName = featName:lower();

    local awVarname = catName .. "." .. featName .. "." .. varname:lower();
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname] =
    gui.Combobox(SuFramework.mainGuiObjects.configureGroup, awVarname, name, unpack(optionsTable))

    if SuFramework.currentColumn == 2 then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosX(300-8);
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosY(SuFramework.currentY);

    if description then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetDescription(description);
        SuFramework.currentY = SuFramework.currentY + 48*1.4;
    else
        SuFramework.currentY = SuFramework.currentY + 48;
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetWidth(300-16-4)

    return SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname];
end

function SuFramework.addColorPicker(varname, name, colorTable, customParent)

    if SuFramework.menuCreated == false then
        return false;
    end

    local catName = SuFramework.categoryNames[SuFramework.categoryCount]
    catName = catName:gsub(" ", "");
    catName = catName:lower();

    local featName = SuFramework.featureNames[SuFramework.categoryCount][SuFramework.featureCount];
    featName = featName:gsub(" ", "");
    featName = featName:lower();

    local awVarname = catName .. "." .. featName .. "." .. varname:lower();

    if customParent then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname] =
        gui.ColorPicker(customParent, awVarname, name, unpack(colorTable))
    else
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname] =
        gui.ColorPicker(SuFramework.mainGuiObjects.configureGroup, awVarname, name, unpack(colorTable))
    end

    if not customParent then
        if SuFramework.currentColumn == 2 then
            SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosX(300-8);
        end
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosY(SuFramework.currentY);

        SuFramework.currentY = SuFramework.currentY + 24;
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetWidth(300-16-4)
    end

    return SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname];
end

function SuFramework.addText(varname, text)

    if SuFramework.menuCreated == false then
        return false;
    end

    local catName = SuFramework.categoryNames[SuFramework.categoryCount]
    catName = catName:gsub(" ", "");
    catName = catName:lower();

    local featName = SuFramework.featureNames[SuFramework.categoryCount][SuFramework.featureCount];
    featName = featName:gsub(" ", "");
    featName = featName:lower();

    local awVarname = catName .. "." .. featName .. "." .. varname:lower();
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname] =
    gui.Text(SuFramework.mainGuiObjects.configureGroup, text)

    if SuFramework.currentColumn == 2 then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosX(300-8);
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosY(SuFramework.currentY);

    SuFramework.currentY = SuFramework.currentY + 24;
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetWidth(300-16-4)

    return SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname];
end

function SuFramework.addEditbox(varname, name, description)

    if SuFramework.menuCreated == false then
        return false;
    end

    local catName = SuFramework.categoryNames[SuFramework.categoryCount]
    catName = catName:gsub(" ", "");
    catName = catName:lower();

    local featName = SuFramework.featureNames[SuFramework.categoryCount][SuFramework.featureCount];
    featName = featName:gsub(" ", "");
    featName = featName:lower();

    local awVarname = catName .. "." .. featName .. "." .. varname:lower();
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname] =
    gui.Editbox(SuFramework.mainGuiObjects.configureGroup, awVarname, name)

    if SuFramework.currentColumn == 2 then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosX(300-8);
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosY(SuFramework.currentY);

    if description then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetDescription(description);
        SuFramework.currentY = SuFramework.currentY + 48*1.5;
    else
        SuFramework.currentY = SuFramework.currentY + 48;
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetWidth(300-16-4)

    return SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname];
end

function SuFramework.addMultibox(varname, name, description)

    if SuFramework.menuCreated == false then
        return false;
    end

    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname] =
    gui.Multibox(SuFramework.mainGuiObjects.configureGroup, name)

    if SuFramework.currentColumn == 2 then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosX(300-8);
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosY(SuFramework.currentY);

    if description then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetDescription(description);
        SuFramework.currentY = SuFramework.currentY + 48*1.5;
    else
        SuFramework.currentY = SuFramework.currentY + 48;
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetWidth(300-16-4)

    return SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname];
end

function SuFramework.addKeybox(varname, name, key, description)

    if SuFramework.menuCreated == false then
        return false;
    end

    local catName = SuFramework.categoryNames[SuFramework.categoryCount]
    catName = catName:gsub(" ", "");
    catName = catName:lower();

    local featName = SuFramework.featureNames[SuFramework.categoryCount][SuFramework.featureCount];
    featName = featName:gsub(" ", "");
    featName = featName:lower();

    local awVarname = catName .. "." .. featName .. "." .. varname:lower();

    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname] =
    gui.Keybox(SuFramework.mainGuiObjects.configureGroup, awVarname, name, key)

    if SuFramework.currentColumn == 2 then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosX(300-8);
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosY(SuFramework.currentY);

    if description then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetDescription(description);
        SuFramework.currentY = SuFramework.currentY + 48*1.5;
    else
        SuFramework.currentY = SuFramework.currentY + 48;
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetWidth(300-16-4)

    return SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname];
end

function SuFramework.addButton(varname, name, callback)

    if SuFramework.menuCreated == false then
        return false;
    end

    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname] =
    gui.Button(SuFramework.mainGuiObjects.configureGroup, name, callback)

    if SuFramework.currentColumn == 2 then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosX(300-8);
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosY(SuFramework.currentY);

    SuFramework.currentY = SuFramework.currentY + 32+16;
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetWidth(300-16-4)

    return SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname];
end

function SuFramework.addListbox(varname, height, optionsTable)

    if SuFramework.menuCreated == false then
        return false;
    end

    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname] =
    gui.Listbox(SuFramework.mainGuiObjects.configureGroup, varname, height, unpack(optionsTable))

    if SuFramework.currentColumn == 2 then
        SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosX(300-8);
    end
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetPosY(SuFramework.currentY);

    SuFramework.currentY = SuFramework.currentY + height+16;
    SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname]:SetWidth(300-16-4)

    return SuFramework.categories[SuFramework.categoryCount][SuFramework.featureCount][varname];
end

function SuFramework.handleUI()

    SuFramework.mainGuiObjects.featureSelector:SetOptions(unpack(SuFramework.featureNames[SuFramework.mainGuiObjects.categorySelector:GetValue() + 1]))

    if SuFramework.lastCategorySelection ~= SuFramework.mainGuiObjects.categorySelector:GetValue()+1 then
        local c = 0;
        for k, v in pairs(SuFramework.featureNames[SuFramework.mainGuiObjects.categorySelector:GetValue() + 1]) do
            c = c + 1;
        end
        if SuFramework.mainGuiObjects.featureSelector:GetValue()+1 > c then
            SuFramework.mainGuiObjects.featureSelector:SetValue(c+1);
        end

        SuFramework.lastCategorySelection = SuFramework.mainGuiObjects.categorySelector:GetValue()+1;
    end

    for catKey, categories in pairs(SuFramework.categories) do
        for featKey, features in pairs(categories) do
            for guiKey, guiObject in pairs(features) do
                if catKey == SuFramework.mainGuiObjects.categorySelector:GetValue() + 1 then
                    if featKey == SuFramework.mainGuiObjects.featureSelector:GetValue() + 1 then
                        guiObject:SetInvisible(false);
                    else
                        guiObject:SetInvisible(true);
                    end
                else
                    guiObject:SetInvisible(true);
                end
            end
        end
    end
end

local function updateCheck()
    if SuFramework.version ~= http.Get(SuFramework.versionLink) then
        local script = file.Open("Modules\\Superyu\\SuFramework.lua", "w");
        newScript = http.Get(SuFramework.link)
        script:Write(newScript);
        script:Close()
        return false;
    else
        return true;
    end
end

if updateCheck() then
    return SuFramework;
else
    return "Updated";
end