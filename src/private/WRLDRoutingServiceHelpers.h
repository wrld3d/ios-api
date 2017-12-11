#pragma once

#include "RoutingQueryResponse.h"
#include "WRLDRoutingQueryResponse.h"

namespace Eegeo
{
    namespace Routes
    {
        namespace Webservice
        {
            namespace Helpers
            {
                WRLDRoutingQueryResponse* CreateWRLDRoutingQueryResponse(const Eegeo::Routes::Webservice::RoutingQueryResponse& result);
            }
        }
    }
}
