// Trigger runs getLocation() on Leads with no Geolocation
trigger SetLeadGeolocation on Lead (after insert, after update) {
    for (Lead l : trigger.new)
        if (l.Location__Latitude__s == null)
            LocationCallouts.getLocation(l.id);
}