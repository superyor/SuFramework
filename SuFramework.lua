--- Still in development, don't use yet.

local framework = {
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
}
framework.__index = framework;

function framework:createMenu(varnamePrefix, reference, tabName)
    if not varnamePrefix then
        return false;
    end

    self.mainGuiObjects.tab = gui.Tab(reference, varnamePrefix .. ".tab", tabName)
    self.mainGuiObjects.selectorGroup = gui.Groupbox(self.mainGuiObjects.tab, "Selector", 16, 16, 600, 64)
    self.mainGuiObjects.categorySelector = gui.Combobox(self.mainGuiObjects.selectorGroup, "selector.category", "Category", "")
    self.mainGuiObjects.featureSelector = gui.Combobox(self.mainGuiObjects.selectorGroup, "selector.feature", "Feature", "")
    self.mainGuiObjects.configureGroup = gui.Groupbox(self.mainGuiObjects.tab, "Configure", 16, 64+64, 600, 64)
    self.mainGuiObjects.categorySelector:SetWidth(300-16-4)
    self.mainGuiObjects.featureSelector:SetPosX(300-8)
    self.mainGuiObjects.featureSelector:SetPosY(0)
    self.mainGuiObjects.featureSelector:SetWidth(300-16-4)
    self.varnamePrefix = varnamePrefix;
    self.menuCreated = true;

    return true;
end

function framework:addCategory(categoryName)

    if self.menuCreated == false then
        return false;
    end

    table.insert(self.categoryNames, categoryName)
    self.mainGuiObjects.categorySelector:SetOptions(unpack(self.categoryNames))
    self.categoryCount = self.categoryCount + 1;
    self.categories[self.categoryCount] = {}
    return true;
end

function framework:addFeature(featureName)

    if self.menuCreated == false then
        return false;
    end

    self.featureNames[self.categoryCount] = {
        [self.featureCount] = featureName;
    };

    self.featureCount = self.featureCount + 1;
    self.categories[self.categoryCount][self.featureCount] = {};
    self.currentColumn = 1;
    self.currentY = 0;
    return true;
end

function framework:addCheckbox(varname, name, defaultValue, description)

    if self.menuCreated == false then
        return false;
    end

    local catName = self.categoryNames[self.categoryCount]
    catName = catName:gsub(" ", "");
    catName = catName:lower();

    local featName = self.featureNames[self.categoryCount][self.featureCount];
    featName = featName:gsub(" ", "");
    featName = featName:lower();

    local awVarname = catName .. "." .. featName .. "." .. varname:lower();
    self.categories[self.categoryCount][self.featureCount][varname] =
    gui.Checkbox(self.mainGuiObjects.configureGroup, awVarname, name, defaultValue);

    if self.currentColumn == 2 then
        self.categories[self.categoryCount][self.featureCount][varname]:SetPosX(300-8);
    end
    self.categories[self.categoryCount][self.featureCount][varname]:SetPosY(self.currentY);

    if description then
        self.categories[self.categoryCount][self.featureCount][varname]:SetDescription(description);
        self.currentY = self.currentY + 28*1.5;
    else
        self.currentY = self.currentY + 28;
    end
    self.categories[self.categoryCount][self.featureCount][varname]:SetWidth(300-16-4)

    return self.categories[self.categoryCount][self.featureCount][varname];
end

function framework:handleUI()
    for catKey, categories in pairs(self.categories) do
        for featKey, features in pairs(categories) do
            for guiKey, guiObject in pairs(features) do

                self.mainGuiObjects.featureSelector:SetOptions(unpack(self.featureNames[self.categoryCount][self.featureCount]))

                if catKey == self.mainGuiObjects.categorySelector:GetValue() + 1 then
                    if featKey == self.mainGuiObjects.featureSelector:GetValue() + 1 then
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

if framework:createMenu("ragesu", gui.Reference("Ragebot"), "RageSU") then
    if framework:addCategory("Test Category") then
        if framework:addFeature("Test Feature") then
            local kek = framework:addCheckbox("testCheck", "Test Checkbox", true, "This is a test checkbox.")
            local kek2 = framework:addCheckbox("testCheck2", "Test Checkbox 2", false, "This is a second test checkbox.")
        end

        if framework:addFeature("Test Feature Two") then
            local kek3 = framework:addCheckbox("testCheck3", "Test Checkbox 3", true, "This is a third test checkbox.")
            local kek4 = framework:addCheckbox("testCheck4", "Test Checkbox 4", true, "This is a fourth test checkbox.")
        end
    end

    if framework:addCategory("Test Category Two") then
        if framework:addFeature("Test Feature") then
            local kek = framework:addCheckbox("testCheck", "Test Checkbox from Test Category 2", true, "This is a test checkbox.")
            local kek2 = framework:addCheckbox("testCheck2", "Test Checkbox 2 from Test Category 2", false, "This is a second test checkbox.")
        end

        if framework:addFeature("Test Feature Two") then
            local kek3 = framework:addCheckbox("testCheck3", "Test Checkbox 3 from Test Category 2", true, "This is a third test checkbox.")
            local kek4 = framework:addCheckbox("testCheck4", "Test Checkbox 4 from Test Category 2", true, "This is a fourth test checkbox.")
        end
    end
end

local function hkDraw()
    framework:handleUI()
end

callbacks.Register("Draw", hkDraw);