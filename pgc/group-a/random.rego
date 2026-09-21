package terraform


random_number = num {
    request := {
        "url": "https://www.random.org/integers/?num=1&min=0&max=1&base=10&col=1&format=plain",
        "method": "GET"
    }
    response := http.send(request)
    response.status_code == 200
    num := to_number(trim(response.raw_body, "\n"))
}

deny[reason] {
    number := random_number
    number == 0

    reason := sprintf(
        "Unlucky you (loh): got %d, but 1 is required",
        [number]
    )
}
# item4 touch both groups

# item3 celery path

# item10 in-flight retrigger

# item7 timeout 60s

# item8 kill agent pod

# item8b fresh dispatch after kill

# item12 unlink env mid-flight

# item12b unlink env via PATCH

# item13b delete group_c mid-flight

# item13c unlink+delete group_c mid-flight

# item18

# item20 vcs outage
