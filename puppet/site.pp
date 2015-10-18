# installed docker user and group to handle properly Docker containers
group {'docker':
    gid => 999,
}

user {'docker':
    uid => 999,
    groups => ['docker'],
}

Group['docker'] -> User['docker']